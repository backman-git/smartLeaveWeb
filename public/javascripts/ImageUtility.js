// Generated by CoffeeScript 1.12.3
(function() {
  $(document).ready(function() {
    var ImageFactory, nameStr, printDayToForm, printImgtoForm, printTextToForm, saveFormToImg, saveImgtoServer, showMark;
    $("#Form").hide();
    ImageFactory = function(ctx) {
      this.ctx = ctx;
      this.drawImage = function(image_arg, image_x, image_y) {
        var _this, image;
        _this = this;
        image = new Image();
        image.onload = function() {
          _this.ctx.drawImage(image, image_x, image_y);
        };
        image.src = image_arg;
      };
    };
    showMark = function(event) {
      var str1, str2, str3;
      $(this).text("");
      str1 = "url(";
      str2 = ")";
      str3 = str1.concat(event.data.p1);
      str3 = str3.concat(str2);
      $(this).css("background-image", str3);
      $(this).css("background-image", str3);
      $(this).css("height", "50px");
      $(this).css("width", "120px");
      $(this).css("left", "350px");
    };
    printTextToForm = function(ID) {
      var ctx, x, y;
      ctx = $("#Canvas")[0].getContext('2d');
      ctx.font = "45px Arial";
      x = parseInt($("#" + ID).css("left"));
      y = parseInt($("#" + ID).css("top"));
      y += 40;
      ctx.fillText($("#" + ID).text(), x, y);
    };
    printDayToForm = function(ID) {
      var ctx, p;
      ctx = $("#Canvas")[0].getContext('2d');
      ctx.font = "20px Arial";
      p = $("#" + ID).offset();
      ctx.fillText($("#" + ID).val(), p.left - 40, p.top);
    };
    printImgtoForm = function(ID) {
      var bgImg, ctx, imageFactory;
      ctx = $("#Canvas")[0].getContext('2d');
      imageFactory = new ImageFactory(ctx);
      bgImg = $("#" + ID).css("background-image");
      bgImg = bgImg.replace('url(', '').replace(')', '').replace(/\"/gi, "");
      imageFactory.drawImage(bgImg, parseInt($("#" + ID).css("left")), parseInt($("#" + ID).css("top")));
    };
    saveFormToImg = function() {
      printTextToForm("name");
      printTextToForm("careerDay");
      printDayToForm("startDay");
      printDayToForm("finishDay");
      printTextToForm("availableDay");
      printTextToForm("useDay");
      if ($("#PersonalMarkButton").length) {
        printImgtoForm("PersonalMarkButton");
      }
      if ($("#DeputyMarkButton").length) {
        printImgtoForm("DeputyMarkButton");
      }
      if ($("#supervisorButton").length) {
        printImgtoForm("supervisorButton");
      }
      saveImgtoServer("/mainPage/upLoadForm", $("#Canvas")[0].toDataURL());
    };
    saveImgtoServer = function(url, data) {
      $.post(url, {
        image: data,
        name: $("#name").text(),
        deputyName: $("#deputyName").val()
      }, function(data, status) {});
      return;
    };
    $("#submit").click(saveFormToImg);
    nameStr = $("#name").text();
    nameStr = nameStr.replace(" ", "");
    $('#PersonalMarkButton').click({
      p1: "../images/" + nameStr + ".jpg"
    }, showMark);
    $('#DeputyMarkButton').click({
      p1: "../images/" + nameStr + ".jpg"
    }, showMark);
    $('#supervisorButton').click({
      p1: "../images/" + nameStr + ".jpg"
    }, showMark);
  });

  $(window).load(function() {
    var renderForm;
    renderForm = function() {
      var ctx, form;
      ctx = $("#Canvas")[0].getContext('2d');
      form = $("#Form")[0];
      ctx.drawImage(form, 0, 0);
    };
    renderForm();
    $(".loader").fadeOut("slow");
  });

}).call(this);
