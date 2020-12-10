package xyz.elitese.ehrenamtskarte.importer

import com.beust.klaxon.Klaxon
import io.ktor.client.HttpClient
import io.ktor.client.request.request
import io.ktor.client.request.url
import io.ktor.http.HttpMethod
import org.jetbrains.exposed.sql.transactions.transaction
import org.postgis.Point
import xyz.elitese.ehrenamtskarte.database.*
import xyz.elitese.ehrenamtskarte.importer.annotations.BooleanField
import xyz.elitese.ehrenamtskarte.importer.annotations.DoubleField
import xyz.elitese.ehrenamtskarte.importer.annotations.IntegerField
import xyz.elitese.ehrenamtskarte.importer.converters.booleanConverter
import xyz.elitese.ehrenamtskarte.importer.converters.doubleConverter
import xyz.elitese.ehrenamtskarte.importer.converters.integerConverter

object AcceptingStoresImporter {

    val URL = ""

    private suspend fun requestFromFreinet(): FreinetData? {
        val client = HttpClient()
        val response = client.request<String> {
            url(URL)
            method = HttpMethod.Get
        }

        return Klaxon()
                .fieldConverter(IntegerField::class, integerConverter)
                .fieldConverter(DoubleField::class, doubleConverter)
                .fieldConverter(BooleanField::class, booleanConverter)
                .parse<FreinetData>(response)
    }

    private fun importSingleAcceptingStore(acceptingStore: FreinetAcceptingStore, category: CategoryEntity) {
        println("import " + acceptingStore.name)

        transaction {
            val address = AddressEntity.new {
                street = acceptingStore.street
                houseNumber = "10"
                postalCode = acceptingStore.postalCode
                locaction = acceptingStore.location
                state = "de"
            }
            val contact = ContactEntity.new {
                email = acceptingStore.email
                telephone = acceptingStore.telephone
                website = acceptingStore.homepage
            }
            val store = AcceptingStoreEntity.new {
                name = acceptingStore.name
                description = acceptingStore.discount
                contactId = contact.id
                categoryId = category.id
            }
            PhysicalStoreEntity.new {
                storeId = store.id
                addressId = address.id
                // coordinates = Point(acceptingStore.longitude, acceptingStore.latitude)
            }
        }
    }

    suspend fun import() {
        val freinetData = requestFromFreinet()

        val publicAcceptingStores = freinetData!!.data.filter { it.public == true }
        var category : CategoryEntity? = null
        transaction {
             category = CategoryEntity.new {
                name = "TestCategory"
            }
        }
        for (acceptingStore in publicAcceptingStores) {
            importSingleAcceptingStore(acceptingStore, category!!)
        }
        println(publicAcceptingStores.size)
    }

}
