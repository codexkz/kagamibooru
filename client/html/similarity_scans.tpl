<div class='content-wrapper similarity-scans'>
    <h1><%= ctx.t('similarity.title') %></h1>

    <% if (ctx.canCreate) { %>
        <form class='similarity-new-scan'>
            <ul class='input'>
                <li>
                    <%= ctx.makeNumericInput({
                        text: ctx.t('similarity.threshold'),
                        name: 'threshold',
                        value: '0.45',
                        min: '0',
                        max: '1',
                        step: '0.01',
                    }) %>
                    <p class='hint'><%= ctx.t('similarity.thresholdHint') %></p>
                </li>
            </ul>
            <div class='buttons'>
                <input type='submit' class='start' value='<%= ctx.t("similarity.startScan") %>'>
            </div>
        </form>
    <% } %>

    <div class='messages'></div>

    <div class='table-wrap'>
        <table class='scans'>
            <thead>
                <tr>
                    <th class='id'><%= ctx.t('similarity.colId') %></th>
                    <th class='created'><%= ctx.t('similarity.colCreated') %></th>
                    <th class='status'><%= ctx.t('similarity.colStatus') %></th>
                    <th class='progress'><%= ctx.t('similarity.colProgress') %></th>
                    <th class='groups'><%= ctx.t('similarity.colGroups') %></th>
                    <th class='actions'></th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
</div>
