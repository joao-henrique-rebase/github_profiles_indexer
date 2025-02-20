import { application } from "./application"

import RescanController from "./rescan_controller"
application.register("rescan", RescanController)

import SearchController from "./search_controller"
application.register("search", SearchController)
