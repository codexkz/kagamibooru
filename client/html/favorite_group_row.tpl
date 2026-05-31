<li data-group-id='<%= ctx.group.id %>'>
    <span class='info'>
        <span class='line'>
            <span class='name'><a href='<%= ctx.formatClientLink("posts", { query: "favgroup:" + ctx.group.name }) %>'><%- ctx.group.name %></a></span><!--
            --><% if (ctx.group.isDefault) { %><span class='default-badge'><%= ctx.t('favGroup.defaultBadge') %></span><% } %><!--
            --><span class='count'>(<%- ctx.group.postCount %>)</span>
        </span>
    </span>
    <span class='row-actions'>
        <a class='rename' href title='<%= ctx.t("favGroup.rename") %>'><i class='fa fa-pencil'></i></a><!--
        --><% if (!ctx.group.isDefault) { %><a class='delete' href title='<%= ctx.t("favGroup.delete") %>'><i class='fa fa-trash-o'></i></a><% } %>
    </span>
</li>
