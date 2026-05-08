<div class='user-list-header'>
    <form class='horizontal'>
        <ul class='input'>
            <li>
                <%= ctx.makeTextInput({text: ctx.t('usersHeader.searchQuery'), id: 'search-text', name: 'search-text', value: ctx.parameters.query}) %>
            </li>
        </ul>

        <div class='buttons'>
            <input type='submit' value='<%= ctx.t("usersHeader.search") %>'/>
            <a class='append' href='<%- ctx.formatClientLink('help', 'search', 'users') %>'><%- ctx.t('usersHeader.syntaxHelp') %></a>
        </div>
    </form>
</div>
