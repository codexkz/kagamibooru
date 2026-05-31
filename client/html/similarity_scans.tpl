<div class='content-wrapper similarity-scans'>
    <h1><%= ctx.t('similarity.title') %></h1>

    <% if (ctx.canCreate) { %>
        <nav class='buttons similarity-tabs'><!--
            --><ul><!--
                --><li data-tab='full'><a href><%= ctx.t('similarity.fullScanTitle') %></a></li><!--
                --><li data-tab='single'><a href><%= ctx.t('similarity.singleTitle') %></a></li><!--
            --></ul><!--
        --></nav>

        <form class='similarity-new-scan tab-pane' data-tab='full'>
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

        <form class='similarity-single-scan tab-pane' data-tab='single'>
            <ul class='input'>
                <li>
                    <%= ctx.makeNumericInput({
                        text: ctx.t('similarity.threshold'),
                        name: 'singleThreshold',
                        value: '0.45',
                        min: '0',
                        max: '1',
                        step: '0.01',
                    }) %>
                </li>
                <li>
                    <%= ctx.makeNumericInput({
                        text: ctx.t('similarity.singlePostId'),
                        name: 'queryPostId',
                        min: '1',
                        step: '1',
                    }) %>
                </li>
            </ul>

            <div class='single-source'>
                <p class='or-divider'><%= ctx.t('similarity.singleOr') %></p>

                <p class='dropper-hint'><%= ctx.t('similarity.singleDropHint') %></p>
                <div class='single-dropper'></div>

                <div class='single-preview' style='display:none'>
                    <img class='thumbnail' alt='preview'>
                    <div class='preview-actions'>
                        <button type='button' class='clear-image'><%= ctx.t('similarity.singleClear') %></button>
                    </div>
                </div>
            </div>

            <div class='buttons'>
                <input type='submit' class='start by-id' value='<%= ctx.t("similarity.singleSearch") %>'>
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
