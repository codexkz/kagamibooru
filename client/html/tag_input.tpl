<div class='tag-input'>
    <div class='main-control'>
        <input type='text' placeholder='<%= ctx.t("tagInput.placeholder") %>'/>
        <button><%= ctx.t('tagInput.add') %></button>
    </div>

    <div class='tag-suggestions'>
        <div class='wrapper'>
            <p>
                <span class='buttons'>
                    <a href class='opacity'><i class='fa fa-eye'></i></a>
                    <a href class='close'>×</a>
                </span>
                <%= ctx.t('tagInput.suggestedTags') %>
            </p>
            <ul></ul>
        </div>
    </div>

    <ul class='compact-tags'></ul>
</div>
