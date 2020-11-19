/*
 * This Kotlin source file was generated by the Gradle 'init' task.
 */
package xyz.elitese.ehrenamtskarte

import io.javalin.Javalin

fun main(args: Array<String>) {
    val app = Javalin.create { cfg ->
        cfg.enableDevLogging()
        cfg.enableCorsForAllOrigins()
    }.start(7000)

    app.get("/") { ctx -> ctx.result("Hello World!") }
    println("Server is running at http://localhost:7000")

    val graphQLHandler = GraphQLHandler()
    app.post("/graphql") { ctx -> graphQLHandler.handle(ctx.req, ctx.res) }
}
