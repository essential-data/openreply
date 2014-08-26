jQuery.fn.center = function () {
    this.css("position","absolute");
    this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) +
        $(window).scrollTop()) + "px");
    this.css("left", $(window).width() - $(this).outerWidth() / 2)
    this.css("margin-left", "-50%")
    return this;
}