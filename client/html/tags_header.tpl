<div class='tag-list-header'>
    <form class='horizontal'>
        <ul class='input'>
            <li>
                <%= ctx.makeTextInput({text: ctx.t('tagsHeader.searchQuery'), id: 'search-text', name: 'search-text', value: ctx.parameters.query}) %>
            </li>
        </ul>

        <div class='buttons'>
            <input type='submit' value='<%= ctx.t("tagsHeader.search") %>'/>
            <a class='button append' href='<%- ctx.formatClientLink('help', 'search', 'tags') %>'><%= ctx.t('tagsHeader.syntaxHelp') %></a>
            <% if (ctx.canEditTagCategories) { %>
                <a class='append' href='<%- ctx.formatClientLink('tag-categories') %>'><%= ctx.t('tagsHeader.categories') %></a>
            <% } %>
        </div>
    </form>
</div>
