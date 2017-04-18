// Generated by CoffeeScript 1.12.3
(function() {
  $(document).ready(function() {
    var ImageFactory, checkForm, dButtonID, pButtonID, printDayToForm, printImgtoForm, printTextToForm, sButtonID, saveFormToImg, saveImgtoServer, showMark;
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
      $(this).css("height", "50px");
      $(this).css("width", "150px");
      $(this).css("left", "280px");
    };
    printTextToForm = function(ID) {
      var ctx, x, y;
      ctx = $("#Canvas")[0].getContext('2d');
      ctx.font = "45px Arial";
      x = parseInt($("#" + ID).css("left"));
      y = parseInt($("#" + ID).css("top"));
      y += 40;
      ctx.fillText($("#" + ID).val(), x, y);
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
    checkForm = function() {
      var alertMsg;
      alertMsg = "";
      switch ($("#role").val()) {
        case "individual":
          if ($('#PersonalMarkButton').text() !== "") {
            alertMsg += "please stamp the mark!\n";
          }
          if ($('#deputyName').val() === "") {
            alertMsg += "deputy name is empty!\n";
          }
          break;
        case "deputy":
          if ($('#DeputyMarkButton').text() !== "") {
            alertMsg += "please stamp the mark!\n";
          }
          break;
        case "boss":
          if ($('#supervisorButton').text() !== "") {
            alertMsg += "please stamp the mark!\n";
          }
      }
      if (alertMsg === "") {
        return saveFormToImg();
      } else {
        alertMsg += "please fill empty fields!";
        return alert(alertMsg);
      }
    };
    saveFormToImg = function() {
      if ($('#name').length) {
        printTextToForm("name");
      }
      if ($('#careerDay').length) {
        printTextToForm("careerDay");
      }
      if ($('#startDay').length) {
        printDayToForm("startDay");
      }
      if ($('#finishDay').length) {
        printDayToForm("finishDay");
      }
      if ($('#availableDay').length) {
        printTextToForm("availableDay");
      }
      if ($('#useDay').length) {
        printTextToForm("useDay");
      }
      if ($("#PersonalMarkButton").length) {
        printImgtoForm("PersonalMarkButton");
      }
      if ($("#DeputyMarkButton").length) {
        printImgtoForm("DeputyMarkButton");
      }
      if ($("#supervisorButton").length) {
        printImgtoForm("supervisorButton");
      }
      if ($("#officeMsg").length) {
        printTextToForm("officeMsg");
        console.log("office");
      }
      if ($("#etc").length) {
        printTextToForm('etc');
        console.log("etc");
      }
      setTimeout(saveImgtoServer, 30);
    };
    saveImgtoServer = function() {
      var data, url;
      url = "/mainPage/upLoadForm";
      data = $("#Canvas")[0].toDataURL();
      $.post(url, {
        image: data,
        fID: $("#fID").val(),
        name: $("#name").text(),
        deputyName: $("#deputyName").val()
      }, function(data, status) {
        window.location.href = "../mainPage";
      });
      return;
    };
    $("#submit").click(checkForm);
    pButtonID = $('#PersonalMarkButton').val();
    $('#PersonalMarkButton').click({
      p1: "../dataPool/mark/" + pButtonID + ".png"
    }, showMark);
    dButtonID = $('#DeputyMarkButton').val();
    $('#DeputyMarkButton').click({
      p1: "../dataPool/mark/" + dButtonID + ".png"
    }, showMark);
    sButtonID = $('#supervisorButton').val();
    $('#supervisorButton').click({
      p1: "../dataPool/mark/" + sButtonID + ".png"
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
