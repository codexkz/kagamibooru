<div class='content-wrapper' id='user'>
    <h1><%- ctx.user.name %></h1>
    <nav class='buttons'><!--
        --><ul><!--
            --><li data-name='summary'><a href='<%- ctx.formatClientLink('user', ctx.user.name) %>'><%- ctx.t('userNav.summary') %></a></li><!--
            --><% if (ctx.canEditAnything) { %><!--
                --><li data-name='edit'><a href='<%- ctx.formatClientLink('user', ctx.user.name, 'edit') %>'><%- ctx.t('userNav.settings') %></a></li><!--
            --><% } %><!--
            --><% if (ctx.canListTokens) { %><!--
                --><li data-name='list-tokens'><a href='<%- ctx.formatClientLink('user', ctx.user.name, 'list-tokens') %>'><%- ctx.t('userNav.loginTokens') %></a></li><!--
                --><li data-name='api-tokens'><a href='<%- ctx.formatClientLink('user', ctx.user.name, 'api-tokens') %>'><%- ctx.t('userNav.apiTokens') %></a></li><!--
            --><% } %><!--
            --><% if (ctx.canDelete) { %><!--
                --><li data-name='delete'><a href='<%- ctx.formatClientLink('user', ctx.user.name, 'delete') %>'><%- ctx.t('userNav.delete') %></a></li><!--
            --><% } %><!--
        --></ul><!--
    --></nav>
    <div id='user-content-holder'></div>
</div>
