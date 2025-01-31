import { application } from "./application"
import PortionsController from "./portions_controller"
import ScrollController from "./scroll_controller"
import ResetFormController from "./reset_form_controller"

application.register("portions", PortionsController)
application.register("scroll", ScrollController)
application.register("reset-form", ResetFormController) 