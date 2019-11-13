function getValue(json, path)
{
    var arr = path.split('/');
    for(var i=0; i<arr.length && json; i++) {
        json = json[arr[i]];
    }
    return json;
}

function sendGetRequest(url, handler)
{
    console.log("sendGetRequest", url)

    if(!xhr) {
        xhr = new XMLHttpRequest();
    }
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            title = "Done";
            if (xhr.status === 200) {
                handler(xhr);
            } else {
                handler(null);
                messageDialog.title = "Error";
                messageDialog.text = xhr.responseText;
                messageDialog.open();
            }
        }
    }
    title = "Waiting response ...";
    xhr.open("GET", url);
    xhr.setRequestHeader( 'Authorization', 'Basic ' + authHash)
    xhr.send();
}

function readIssues(queryUrl)
{
    sendGetRequest(queryUrl, function(request) {
        if (request === null) {
            mainModel = [];
        } else {
            var data = JSON.parse(request.responseText);
            var rangeStart = data["startAt"];
            var results = data["issues"].length;
            totalIssuies = data["total"];
            mainModel = data["issues"];
            title = "View " + rangeStart + " - " + results + " (total " + totalIssuies + ")";
        }
        repaintKanban();
    });
}

function readProjects(url)
{
    sendGetRequest(url + "/rest/api/2/project", function(request) {
        console.log("readProjects", request);
        if (request === null) {
            projects = [];
        } else {
            projects = JSON.parse(request.responseText);
        }
    });
}

function repaintKanban()
{
    saveSetting('jiraGroupIndex', kanbanParams1.groupVariant)

    model.clear()
    var list = mainModel
    var groupPath = kanbanParams1.groupPath;
    var models = {}
    var groups =  kanbanParams1.groupVariant === 0 && defaultGroups.length > 0 ? defaultGroups.split(";") : [];

    for(var i in list) {
        var item = list[i]
        var g = getValue(item, groupPath)
        if(!(g in models))
            models[g] = []
        models[g].push({ issueRecord: item } )
    }
    if (groups.length === 0) {
        groups = []
        for(g in models)
            groups.push(g)
    }
    for(i in groups) {
        g = groups[i]
        var iss = []
        if(g in models)
            iss = models[g]
        if(g === null)
            g = '(null)'
        model.append({groupName: g, issueList: iss});
    }
}

function loadSettings()
{
    var dbConn = LocalStorage.openDatabaseSync("JKanban", "1.0", "", 1000000);

    dbConn.transaction(
                function(tx) {
                    // Create the database if it doesn't already exist
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Settings(skey TEXT, svalue TEXT)');
                    var rs = tx.executeSql('select skey, svalue from Settings')

                    var r = ""
                    var c = rs.rows.length
                    for(var i = 0; i < rs.rows.length; i++) {
                        var skey = rs.rows.item(i).skey
                        var svalue = rs.rows.item(i).svalue
                        if(skey === 'jiraGroupIndex')
                            kanbanParams1.groupVariant = svalue
                        else if(skey === 'query')
                            queryEdit.text = svalue
                        else if(skey === 'auth')
                            authHash = svalue
                        else if(skey === 'user')
                            user = svalue
                        else if(skey === 'url')
                            url = svalue
                    }
                }
                )
}

function saveSetting(skey, svalue)
{
    var dbConn = LocalStorage.openDatabaseSync("JKanban", "1.0", "", 1000000);
    dbConn.transaction(
                function(tx)
                {
                    tx.executeSql('delete from Settings where skey = ?', [ skey ]);
                    tx.executeSql('INSERT INTO Settings VALUES(?, ?)', [ skey, svalue ]);
                }
                )
}

function readIssuesSimple(queryUrl)
{
    saveSetting('query',queryUrl)
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState === XMLHttpRequest.DONE) {
            var data = JSON.parse(doc.responseText);
            mainModel = data["issues"]
            model.clear()
            var list = mainModel
            var gPath = "fields/assignee/displayName"
            var models = {}
            for(var i in list) {
                var item = list[i]
                var g = getValue(item, gPath)
                if(!(g in models))
                    models[g] = []
                models[g].push({ issueRecord: item } )
            }
            for(g in models) {
                var iss = models[g]
                if(g === null)
                    g = '(null)'
                model.append({
                                 groupName: g,
                                 issueList: iss
                             });
            }
        }
    }
    doc.open("GET", queryUrl);
    doc.send();
}

