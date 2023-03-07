import SimpleSchema from "simpl-schema";
// import { AutoFormPlainTheme } from 'meteor/communitypackages:autoform-plain/static'
import 'bootstrap'
import 'bootstrap/dist/css/bootstrap.css'            // optional, default theme
// import '@fortawesome/fontawesome-free/js/all.js' // optional, is using FA5
import popper from 'popper.js'
import { AutoFormThemeBootstrap4 } from 'meteor/communitypackages:autoform-bootstrap4/static'

global.Popper = popper                           // fix Popper.js issues
SimpleSchema.extendOptions(['autoform']);

AutoFormThemeBootstrap4.load()

AutoFormPlainTheme.load()
// AutoForm.setDefaultTemplate('plain')

new SimpleSchema({
  name: String,
}).validate({
  name: 2,
});
