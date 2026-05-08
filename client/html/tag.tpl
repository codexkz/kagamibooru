<div class='content-wrapper' id='tag'>
    <h1><%- ctx.getPrettyName(ctx.tag.names[0]) %></h1>
    <nav class='buttons'><!--
        --><ul><!--
            --><li data-name='summary'><a href='<%- ctx.formatClientLink('tag', ctx.tag.names[0]) %>'><%- ctx.t('tagNav.summary') %></a></li><!--
            --><% if (ctx.canEditAnything) { %><!--
                --><li data-name='edit'><a href='<%- ctx.formatClientLink('tag', ctx.tag.names[0], 'edit') %>'><%- ctx.t('tagNav.edit') %></a></li><!--
            --><% } %><!--
            --><% if (ctx.canMerge) { %><!--
                --><li data-name='merge'><a href='<%- ctx.formatClientLink('tag', ctx.tag.names[0], 'merge') %>'><%- ctx.t('tagNav.mergeWith') %></a></li><!--
            --><% } %><!--
            --><% if (ctx.canDelete) { %><!--
                --><li data-name='delete'><a href='<%- ctx.formatClientLink('tag', ctx.tag.names[0], 'delete') %>'><%- ctx.t('tagNav.delete') %></a></li><!--
            --><% } %><!--
        --></ul><!--
    --></nav>
    <div class='tag-content-holder'></div>
</div>
