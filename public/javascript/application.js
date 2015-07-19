$(document).ready(function() {

	$('#slide').hover(function () {
		$(this).stop().animate({left:"0px"},500);     
	},function () {
		var width = $(this).width() -10;
		$(this).stop().animate({left: - width  },500);     
	});

});
