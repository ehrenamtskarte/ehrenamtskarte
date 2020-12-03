package xyz.elitese.ehrenamtskarte

import com.expediagroup.graphql.extensions.print
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.options.option
import xyz.elitese.ehrenamtskarte.webservice.GraphQLHandler
import xyz.elitese.ehrenamtskarte.webservice.WebService
import java.io.File


class Entry : CliktCommand() {
    private val exportApi by option(help = "Export GraphQL schema. Given ")

    override fun run() {
        val exportApi = exportApi
        if (exportApi != null) {
            val schema = GraphQLHandler.graphQLSchema.print()
            val file = File(exportApi)
            file.writeText(schema)
        } else {
            WebService().start()
        }
    }
}

fun main(argv: Array<String>) = Entry().main(argv)