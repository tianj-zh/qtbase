import qbs
import QtMultiplexConfig

QtProduct {
    type: "application"
    aggregate: false
    qbs.buildVariants: QtMultiplexConfig.debug_and_release ? ["debug"] : []
}
