package app.ehrenamtskarte.backend.stores.importer.steps

import app.ehrenamtskarte.backend.stores.importer.PipelineStep
import app.ehrenamtskarte.backend.stores.importer.matchesNa
import app.ehrenamtskarte.backend.stores.importer.types.ImportAcceptingStore
import app.ehrenamtskarte.backend.stores.importer.types.LbeAcceptingStore
import org.slf4j.Logger

class DataTransformation(private val logger: Logger) : PipelineStep<List<ImportAcceptingStore>, List<ImportAcceptingStore>>() {

    override fun execute(input: List<ImportAcceptingStore>) = input.map {
        val pc = it.postalCode
        it.copy(
            categoryId = if (it.categoryId == 99) 9 else it.categoryId,
            postalCode = if (pc != null && matchesNa(pc)) "" else pc
        )
    }

}
