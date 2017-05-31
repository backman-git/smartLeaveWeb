// Generated by CoffeeScript 1.12.3
(function() {
  $(document).ready(function() {
    var ImageFactory, cancelForm, checkForm, dButtonID, delay, pButtonID, printDayToForm, printImgtoForm, printTextToForm, sButtonID, saveFormToImg, saveImgtoServer, showMark, ssButtonID;
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
      $(this).css("height", "80px");
      $(this).css("width", "200px");
      $(this).css("left", "300px");
    };
    printTextToForm = function(ID) {
      var ctx, x, y;
      ctx = $("#Canvas")[0].getContext('2d');
      if (ID === "startH" || ID === "finishH") {
        ctx.font = "20px DFKai-sb";
      } else {
        ctx.font = "40px DFKai-sb";
      }
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
      ctx.fillText($("#" + ID).val(), p.left + 30, p.top);
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
      var alertMsg, deffDay, diffDay, fDay, fDay_ms, sDay, sDay_ms;
      fDay = null;
      sDay = null;
      deffDay = 0;
      alertMsg = "";
      switch ($("#role").val()) {
        case "individual":
          fDay = new Date($('#finishDay').val());
          sDay = new Date($('#startDay').val());
          fDay_ms = fDay.getTime();
          sDay_ms = sDay.getTime();
          if (isNaN(fDay) || isNaN(sDay)) {
            alertMsg += "日期未填!\n";
          }
          if (sDay_ms > fDay_ms) {
            alertMsg += "結束時間小於開始時間!\n";
          }
          if ($('#PersonalMarkButton').text() !== "") {
            alertMsg += "請蓋章!\n";
          }
          if ($('#deputyName').val() === "") {
            alertMsg += "代理人姓名空白!\n";
          }
          break;
        case "deputy":
          if ($('#DeputyMarkButton').text() !== "") {
            alertMsg += "請蓋章!\n";
          }
          break;
        case "firstBoss":
          if ($('#supervisorButton').text() !== "") {
            alertMsg += "請蓋章!\n";
          }
          break;
        case "secondBoss":
          if ($('#secondSupervisorButton').text() !== "") {
            alertMsg += "請蓋章!\n";
          }
      }
      if (alertMsg === "") {
        diffDay = (fDay_ms - sDay_ms) / (1000 * 60 * 60 * 24);
        return saveFormToImg(diffDay);
      } else {
        alertMsg += "==============\n";
        alertMsg += "請完成上述資料";
        return alert(alertMsg);
      }
    };
    delay = function(ms, func) {
      return setTimeout(func, ms);
    };
    saveFormToImg = function(diffDay) {
      if ($('#team').length) {
        printTextToForm("team");
      }
      if ($('#name').length) {
        printTextToForm("name");
      }
      if ($('#title').length) {
        printTextToForm("title");
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
        console.log($('#useDay').val());
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
      if ($("#secondSupervisorButton").length) {
        printImgtoForm("secondSupervisorButton");
      }
      if ($("#officeMsg").length) {
        printTextToForm("officeMsg");
        console.log("office");
      }
      if ($("#etc").length) {
        printTextToForm('etc');
        console.log("etc");
      }
      if ($("#startH").length) {
        printTextToForm('startH');
      }
      if ($('#finishH').length) {
        printTextToForm('finishH');
      }
      delay(30, function() {
        return saveImgtoServer(diffDay);
      });
    };
    saveImgtoServer = function(diffDay) {
      var data, fType, url;
      url = "/mainPage/upLoadForm";
      data = $("#Canvas")[0].toDataURL();
      fType = "";
      if (diffDay === 0) {
        fType = null;
      } else if (diffDay < 3) {
        fType = "short";
      } else {
        fType = "long";
      }
      console.log(diffDay);
      $.post(url, {
        image: data,
        fID: $("#fID").val(),
        name: $("#name").text(),
        deputyName: $("#deputyName").val(),
        fType: fType,
        reqDay: diffDay
      }, function(data, status) {
        if (data === "指定代理人不存在") {
          alert(data);
        } else {
          window.location.href = "../mainPage";
        }
      });
      return;
    };
    cancelForm = function(event) {
      var url;
      url = "/mainPage/cancelForm";
      if (confirm("確定取消假單?")) {
        $.post(url, {
          name: event.data.name,
          fID: $("#fID").val()
        }, function(data, status) {
          window.location.href = "../mainPage";
        });
        return;
      }
    };
    $("#submit").click(checkForm);
    $("#cancel").click({
      name: $("#editor").val()
    }, cancelForm);
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
    ssButtonID = $('#secondSupervisorButton').val();
    $('#secondSupervisorButton').click({
      p1: "../dataPool/mark/" + ssButtonID + ".png"
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
