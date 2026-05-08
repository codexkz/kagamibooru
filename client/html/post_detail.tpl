<div class='content-wrapper' id='post'>
    <h1>Post #<%- ctx.post.id %></h1>
    <nav class='buttons'><!--
        --><ul><!--
            --><li><a href='<%- ctx.formatClientLink('post', ctx.post.id) %>'><i class='fa fa-reply'></i> <%= ctx.t('post.mainView') %></a></li><!--
            --><% if (ctx.canMerge) { %><!--
                --><li data-name='merge'><a href='<%- ctx.formatClientLink('post', ctx.post.id, 'merge') %>'><%= ctx.t('post.mergeWith') %></a></li><!--
            --><% } %><!--
        --></ul><!--
    --></nav>
    <div class='post-content-holder'></div>
</div>
