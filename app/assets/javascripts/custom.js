/**
 * Created with JetBrains RubyMine.
 * User: Admin
 * Date: 10/19/12
 * Time: 12:10 PM
 * To change this template use File | Settings | File Templates.
 */
jQuery(document).ready(function(e){
//    $(".localAdminEditPannel ,div.menu_body").hide();
    $(".firstpane a.menu_head").click(function()
    {

        $(this).next("div.menu_body").slideToggle(300).siblings("div.menu_body").slideUp("");

    });
    $(".span3 .side_pannel_header").click(function()
    {

        $(this).next(".localAdminEditPannel").slideToggle("slow").siblings(".localAdminEditPannel").slideUp();
        $("div.menu_body").slideUp();
    });

});
