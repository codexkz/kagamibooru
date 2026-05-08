<div class='content-wrapper' id='pool'>
    <h1><%- ctx.getPrettyName(ctx.pool.names[0]) %></h1>
    <nav class='buttons'><!--
        --><ul><!--
            --><li data-name='summary'><a href='<%- ctx.formatClientLink('pool', ctx.pool.id) %>'><%- ctx.t('poolNav.summary') %></a></li><!--
            --><% if (ctx.canEditAnything) { %><!--
                --><li data-name='edit'><a href='<%- ctx.formatClientLink('pool', ctx.pool.id, 'edit') %>'><%- ctx.t('poolNav.edit') %></a></li><!--
            --><% } %><!--
            --><% if (ctx.canMerge) { %><!--
                --><li data-name='merge'><a href='<%- ctx.formatClientLink('pool', ctx.pool.id, 'merge') %>'><%- ctx.t('poolNav.mergeWith') %></a></li><!--
            --><% } %><!--
            --><% if (ctx.canDelete) { %><!--
                --><li data-name='delete'><a href='<%- ctx.formatClientLink('pool', ctx.pool.id, 'delete') %>'><%- ctx.t('poolNav.delete') %></a></li><!--
            --><% } %><!--
        --></ul><!--
    --></nav>
    <div class='pool-content-holder'></div>
</div>
