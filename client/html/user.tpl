<div class='content-wrapper' id='user'>
    <h1><%- ctx.user.name %></h1>
    <nav class='buttons'><!--
        --><ul><!--
            --><li data-name='summary'><a href='<%- ctx.formatClientLink('user', ctx.user.name) %>'><%- ctx.t('userNav.summary') %></a></li><!--
            --><% if (ctx.canEditAnything) { %><!--
                --><li data-name='edit'><a href='<%- ctx.formatClientLink('user', ctx.user.name, 'edit') %>'><%- ctx.t('userNav.settings') %></a></li><!--
            --><% } %><!--
            --><% if (ctx.canListTokens) { %><!--
                --><li data-name='tokens'><a href='<%- ctx.formatClientLink('user', ctx.user.name, 'tokens') %>'><%- ctx.t('userNav.tokens') %></a></li><!--
            --><% } %><!--
            --><% if (ctx.canManageFavoriteGroups) { %><!--
                --><li data-name='favorite-groups'><a href='<%- ctx.formatClientLink('user', ctx.user.name, 'favorite-groups') %>'><%- ctx.t('userNav.favoriteGroups') %></a></li><!--
            --><% } %><!--
            --><% if (ctx.canDelete) { %><!--
                --><li data-name='delete'><a href='<%- ctx.formatClientLink('user', ctx.user.name, 'delete') %>'><%- ctx.t('userNav.delete') %></a></li><!--
            --><% } %><!--
        --></ul><!--
    --></nav>
    <div id='user-content-holder'></div>
</div>
