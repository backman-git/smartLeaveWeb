// Generated by CoffeeScript 1.12.3
(function() {
  var LeaveForm, LeaveSystem, LeaveSystemSingleton, Node, People, clone, debug, emptyFunction, genHT_of_Tree;

  Node = require("./Node");

  People = require("./People");

  LeaveForm = require("./LeaveForm");

  debug = require('debug')('smartLeave:LSys');

  LeaveSystem = (function() {
    function LeaveSystem(mainTreeRoot) {
      this.mainTreeRoot = mainTreeRoot;
      this.formsList = {};
      this.treeHT = genHT_of_Tree(this.mainTreeRoot);
    }

    LeaveSystem.prototype.addPeople = function(p) {
      this.treeHT[p.name] = new Node(p);
    };

    LeaveSystem.prototype.getPeopleByName = function(name) {
      var t;
      if (name in this.treeHT) {
        t = this.treeHT[name];
        return t.value;
      } else {
        return null;
      }
    };

    LeaveSystem.prototype.getSecurityLevelByName = function(name) {
      return this.treeHT[name].value.level;
    };

    LeaveSystem.prototype.getPeopleNodeByName = function(name) {
      return this.treeHT[name].value;
    };

    LeaveSystem.prototype.getSecurityLevelByFID = function(FID) {
      var name;
      name = this.getNameByFID(FID);
      return this.treeHT[name].value.level;
    };

    LeaveSystem.prototype.getNameByFID = function(FID) {
      FID = FID.split("-", 2);
      return FID[1];
    };

    LeaveSystem.prototype.showArchitecture = function() {
      var a, c, currentLevel, i, k, len, queue, ref, ref1, v;
      debug("------------------------------------------\n");
      queue = [];
      if (this.mainTreeRoot === null) {
        debug("Null");
      } else {
        queue.push(this.mainTreeRoot);
        currentLevel = this.mainTreeRoot.value.level;
        while (queue.length !== 0) {
          a = queue.shift();
          if (currentLevel < a.value.level) {
            currentLevel = a.value.level;
            debug("\n");
          }
          process.stdout.write(a.value.name + ": ");
          ref = a.value.getWaitHQueue();
          for (k in ref) {
            v = ref[k];
            process.stdout.write("(" + k + "," + v + ") ");
          }
          ref1 = a.getChild();
          for (i = 0, len = ref1.length; i < len; i++) {
            c = ref1[i];
            queue.push(c);
          }
        }
      }
      return debug("\n\n------------------------------------------\n");
    };

    LeaveSystem.prototype.addFormToFormsList = function(form) {
      if (form.name in this.formsList) {
        return this.formsList[form.name][form.fileID] = form;
      } else {
        this.formsList[form.name] = {};
        return this.formsList[form.name][form.fileID] = form;
      }
    };

    LeaveSystem.prototype.addNewForm = function(form) {
      this.treeHT[form.name].value.addFormToWaitHQueue(form);
      return this.addFormToFormsList(form);
    };

    LeaveSystem.prototype.getFormsList = function() {
      return clone(this.formsList);
    };

    LeaveSystem.prototype.getRole = function(name, FID) {
      var fState, form, role;
      form = getFormByFID(FID);
      fState = form.getState();
      role = "";
      if (this.getSecurityLevelByName(name) === 0) {
        role = "personnel";
      } else if (this.getNameByFID(FID) === name) {
        role = "individual";
      } else if (this.getSecurityLevelByName(name) >= this.getSecurityLevelByFID(FID) && fState['deputy'] === false) {
        role = "deputy";
      } else if (this.getSecurityLevelByName(name) <= this.getSecurityLevelByFID(FID) && fState['firstBoss'] === false) {
        role = "firstBoss";
      } else if (this.getSecurityLevelByName(name) < this.getSecurityLevelByFID(FID) && fState['secondBoss'] === false) {
        role = "secondBoss";
      } else {
        role = "Error";
      }
      return role;
    };

    LeaveSystem.prototype.checkFormFinish = function(form) {
      var k, ref, v;
      ref = form.getState();
      for (k in ref) {
        v = ref[k];
        if (v === false) {
          return false;
        }
      }
      return true;
    };

    LeaveSystem.prototype.pushToReviewQ = function(form) {
      return this.treeHT["假單庫"].value.addFormToWaitHQueue(form);
    };

    LeaveSystem.prototype.submitFormByID = function(name, FID) {
      var deputy, form, p, pParent, role;
      role = this.getRole(name, FID);
      p = this.treeHT[name].value;
      form = p.retriveFormByFID(FID);
      form.setState(role, true);
      debug(role);
      if (role === "personnel") {
        p.addFormToWaitHQueue(form);
        return this.pushToReviewQ(form);
      } else if (role === "firstBoss") {
        pParent = this.treeHT[name].getParent().value;
        return pParent.addFormToWaitHQueue(form);
      } else if (role === "secondBoss" && form.getType() === "short") {
        p.addFormToWaitHQueue(form);
        return this.pushToReviewQ(form);
      } else if (role === "secondBoss" && form.getType() === "long") {
        pParent = this.treeHT[name].getParent().value;
        return pParent.addFormToWaitHQueue(form);
      } else if (role === "deputy") {
        pParent = this.treeHT[name].getParent().value;
        return pParent.addFormToWaitHQueue(form);
      } else if (role === "individual") {
        deputy = this.treeHT[form.getRoleName("deputy")];
        deputy = deputy.value;
        return deputy.addFormToWaitHQueue(form);
      }
    };

    LeaveSystem.prototype.getPersonFormListByName = function(name) {
      return clone(this.formsList[name]);
    };

    LeaveSystem.prototype.getFormByFID = function(id) {
      var fList, name;
      name = this.getNameByFID(id);
      fList = this.getPersonFormListByName(name);
      return clone(fList[id]);
    };

    return LeaveSystem;

  })();

  genHT_of_Tree = function(root) {
    var HT, a, c, currentLevel, i, len, queue, ref;
    HT = {};
    queue = [];
    if (root === null) {
      debug("Null");
    } else {
      queue.push(root);
      currentLevel = root.value.level;
      while (queue.length !== 0) {
        a = queue.shift();
        HT[a.value.name] = a;
        ref = a.getChild();
        for (i = 0, len = ref.length; i < len; i++) {
          c = ref[i];
          queue.push(c);
        }
      }
    }
    return HT;
  };

  clone = function(obj) {
    var flags, key, newInstance;
    if ((obj == null) || typeof obj !== 'object') {
      return obj;
    }
    if (obj instanceof Date) {
      return new Date(obj.getTime());
    }
    if (obj instanceof RegExp) {
      flags = '';
      if (obj.global != null) {
        flags += 'g';
      }
      if (obj.ignoreCase != null) {
        flags += 'i';
      }
      if (obj.multiline != null) {
        flags += 'm';
      }
      if (obj.sticky != null) {
        flags += 'y';
      }
      return new RegExp(obj.source, flags);
    }
    newInstance = new obj.constructor();
    for (key in obj) {
      newInstance[key] = clone(obj[key]);
    }
    return newInstance;
  };

  emptyFunction = function() {};

  LeaveSystemSingleton = (function() {
    function LeaveSystemSingleton() {}

    LeaveSystemSingleton.instance = null;

    LeaveSystemSingleton.treeNodes = {};

    LeaveSystemSingleton.readFlag = false;

    LeaveSystemSingleton.get = function() {
      if (this.readFlag === false) {
        return null;
      } else if (this.instance !== null) {
        return this.instance;
      } else {
        debug("LSys is ready to go");
        this.instance = new LeaveSystem(this.treeNodes['假單庫']);
        return this.instance;
      }
    };

    LeaveSystemSingleton.buildTree = function(pList) {
      var i, key, len, n, p, ref;
      for (i = 0, len = pList.length; i < len; i++) {
        p = pList[i];
        this.treeNodes[p.name] = new Node(p);
      }
      ref = this.treeNodes;
      for (key in ref) {
        n = ref[key];
        if (n.value.boss !== "") {
          n.setParent(this.treeNodes[n.value.boss]);
        }
      }
      return this.treeNodes;
    };

    LeaveSystemSingleton.setReady = function(f) {
      this.readFlag = f;
    };

    return LeaveSystemSingleton;

  })();

  module.exports = LeaveSystemSingleton;

}).call(this);