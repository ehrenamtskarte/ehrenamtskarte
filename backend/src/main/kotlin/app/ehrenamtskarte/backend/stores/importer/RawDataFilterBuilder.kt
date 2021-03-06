package app.ehrenamtskarte.backend.stores.importer

import app.ehrenamtskarte.backend.stores.importer.types.LbeAcceptingStore
import org.slf4j.Logger

data class FilterBuilder(val store: LbeAcceptingStore, val logger: Logger) {

    fun filterLongitudeAndLatitude()
            = if (store.longitude.isNullOrBlank() || store.latitude.isNullOrBlank()) {
        logger.info("$store was filtered out because longitude or latitude were invalid")
        false
    } else {
        true
    }

    fun filterPostalCode(): Boolean {
        val pc = store.postalCode
        val valid = store.postalCode == null
                || store.postalCode?.trim()?.length == 5
                || store.postalCode?.trim()?.length == 0 // must be 5 symbols or completely empty!
                || pc != null && matchesNa(pc)

        if (!valid)
            logger.info("$store was filtered out because postal code is invalid")

        return valid
    }

    fun filterCategory(): Boolean {
        val category = store.category
        val valid = category?.toIntOrNull() in 0..8 // expected categories
                || category?.toIntOrNull() == 99
                || category?.toIntOrNull() == 9

        if (!valid)
            logger.info("$store was filtered out because category was invalid")

        return valid
    }

}
