<div class='pool-list-header'>
    <form class='horizontal'>
        <ul class='input'>
            <li>
                <%= ctx.makeTextInput({text: ctx.t('poolsHeader.searchQuery'), id: 'search-text', name: 'search-text', value: ctx.parameters.query}) %>
            </li>
        </ul>

        <div class='buttons'>
            <input type='submit' value='<%= ctx.t("poolsHeader.search") %>'/>
            <a class='button append' href='<%- ctx.formatClientLink('help', 'search', 'pools') %>'><%- ctx.t('poolsHeader.syntaxHelp') %></a>

            <% if (ctx.canCreate) { %>
                <a class='append' href='<%- ctx.formatClientLink('pool', 'create') %>'><%- ctx.t('poolsHeader.addNewPool') %></a>
            <% } %>

            <% if (ctx.canEditPoolCategories) { %>
                <a class='append' href='<%- ctx.formatClientLink('pool-categories') %>'><%- ctx.t('poolsHeader.poolCategories') %></a>
            <% } %>
        </div>
    </form>
</div>
