/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

function showRequestInfo(text) {
        msg.text = msg.text + "\n" + text
}

function makeRequest()
{

    var doc = new XMLHttpRequest();
    msg.text = "";
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {
            showRequestInfo("Headers -->");
            showRequestInfo(doc.getAllResponseHeaders ());
            showRequestInfo("Last modified -->");
            showRequestInfo(doc.getResponseHeader ("Last-Modified"));

        } else if (doc.readyState == XMLHttpRequest.DONE) {
            var a = doc.responseXML.documentElement;
            for (var ii = 0; ii < a.childNodes.length; ++ii) {
                showRequestInfo(a.childNodes[ii].nodeName);
            }
            showRequestInfo("Headers -->");
            showRequestInfo(doc.getAllResponseHeaders ());
            showRequestInfo("Last modified -->");
            showRequestInfo(doc.getResponseHeader ("Last-Modified"));
        }
    }

    doc.open("GET", "data.xml");
    doc.send();
}

function getValue(json, path)
{
    var arr = path.split('/');
    for(var i=0; i<arr.length && json; i++) {
        json = json[arr[i]];
    }
    return json;
}

function readIssues()
{
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {
            //                    showRequestInfo("Headers -->");
            //                    showRequestInfo(doc.getAllResponseHeaders ());
            //                    showRequestInfo("Last modified -->");
            //                    showRequestInfo(doc.getResponseHeader ("Last-Modified"));

        } else if (doc.readyState == XMLHttpRequest.DONE) {
            var data = JSON.parse(doc.responseText);
            model.clear();
            var groups = applicationWindow1.jiraGroups.split(';')
            var models = {}
            var list = data["issues"];
            for (var i in list) {
                var item = list[i]
                var v = getValue(item,"fields/status/name")
                if(!(v in models))
                    models[v] = []
                models[v].push({ issueRecord: item }
//                               {
//                                   key: item["key"],
//                                   summary: getValue(item,"fields/summary"),
//                                   assignee: getValue(item,"fields/assignee/displayName"),
//                                   creator: getValue(item,"fields/creator/displayName"),
//                                   status: getValue(item,"fields/status/name"),
//                                   priority: getValue(item,"fields/priority"),
//                                   resolution: getValue(item,"fields/resolution")
//                               }
                               )
            }
            for(var i in groups)
            {
                var g = groups[i]
                var iss = []
                if(g in models)
                    iss = models[g]
                model.append({
                                 groupName: g,
                                 issueList: iss
                             });
            }
        }
    }
    var url = "https://jira.atlassian.com/rest/api/2/search?jql=project = 'JIRA Server (including JIRA Core)' AND updated >= -1w&maxResults=10"
    var local = "file:///C:/Projects/qml/search.json"
    doc.open("GET", local);
    doc.send();
}
