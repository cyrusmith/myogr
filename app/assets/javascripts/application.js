// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require jquery.ui.datepicker-ru
//= require jquery.moodular
//= require chosen-jquery
//= require select2
//= require select2_locale_ru
//= require krutilka
//= require kickstart/kickstart
//= require common
//= require dataTables/jquery.dataTables
//= require date.format


$(document).ready(function () {
    jQuery.fn.reverseEach = (function () {
        var list = jQuery([1]);
        return function (c) {
            var el, i = this.length;
            try {
                while (i-- > 0 && (el = list[0] = this[i]) && c.call(list, i, el) !== false);
            }
            catch (e) {
                delete list[0];
                throw e;
            }
            delete list[0];
            return this.get(0);
        };
    }());
//    $(':password').showPassword();
});
