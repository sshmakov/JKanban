function getValue(json, path)
{
    var arr = path.split('/');
    for(var i=0; i<arr.length && json; i++) {
        json = json[arr[i]];
    }
    return json;
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

function readIssues(queryUrl)
{
    saveSetting('query',queryUrl)
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            var data = JSON.parse(doc.responseText);
            mainModel = data["issues"]
            repaintKanban()
        }
    }
    var url = "https://jira.atlassian.com/rest/api/2/search?jql=project = 'JIRA Server (including JIRA Core)' AND updated >= -1w&maxResults=10"
    var local = "file:///C:/Projects/qml/search.json"
    doc.open("GET", queryUrl);
    doc.send();
}

function repaintKanban()
{
    saveSetting('jiraGroups', kanbanParams1.groupList)
    saveSetting('jiraGroupIndex', kanbanParams1.groupVariant)
    model.clear()
    var list = mainModel
    var groups = kanbanParams1.groupList.trim().split(',')
    var gPath = kanbanParams1.groupValuePath
    var models = {}
    for(var i in list) {
        var item = list[i]
        var g = getValue(item, gPath)
        if(!(g in models))
            models[g] = []
        models[g].push({ issueRecord: item } )
    }
    if(groups.length === 0 ||
            (groups.length === 1 && groups[0] === '')) {
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
        model.append({
                         groupName: g,
                         issueList: iss
                     });
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
                        if(skey === 'jiraGroups')
                            kanbanParams1.groupList = svalue
                        else if(skey === 'jiraGroupIndex')
                            kanbanParams1.groupVariant = svalue
                        else if(skey === 'query')
                            queryTE.text = svalue
                    }
                }
                )

}

