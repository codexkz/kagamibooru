<p><strong><%= ctx.t('help.search.anonymousTokens') %></strong></p>

<p><%= ctx.t('help.search.sameAs').replace('{token}', '<code>tag</code>') %></p>

<p><strong><%= ctx.t('help.search.namedTokens') %></strong></p>

<table>
    <tbody>
        <tr>
            <td><code>id</code></td>
            <td><%= ctx.t('help.searchPosts.id') %></td>
        </tr>
        <tr>
            <td><code>tag</code></td>
            <td><%= ctx.t('help.searchPosts.tag') %></td>
        </tr>
        <tr>
            <td><code>score</code></td>
            <td><%= ctx.t('help.searchPosts.score') %></td>
        </tr>
        <tr>
            <td><code>uploader</code></td>
            <td><%= ctx.t('help.searchPosts.uploader') %></td>
        </tr>
        <tr>
            <td><code>upload</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>uploader</code>') %></td>
        </tr>
        <tr>
            <td><code>submit</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>uploader</code>') %></td>
        </tr>
        <tr>
            <td><code>comment</code></td>
            <td><%= ctx.t('help.searchPosts.comment') %></td>
        </tr>
        <tr>
            <td><code>fav</code></td>
            <td><%= ctx.t('help.searchPosts.fav') %></td>
        </tr>
        <tr>
            <td><code>source</code></td>
            <td><%= ctx.t('help.searchPosts.source') %></td>
        </tr>
        <tr>
            <td><code>pool</code></td>
            <td><%= ctx.t('help.searchPosts.pool') %></td>
        </tr>
        <tr>
            <td><code>tag-count</code></td>
            <td><%= ctx.t('help.searchPosts.tagCount') %></td>
        </tr>
        <tr>
            <td><code>comment-count</code></td>
            <td><%= ctx.t('help.searchPosts.commentCount') %></td>
        </tr>
        <tr>
            <td><code>fav-count</code></td>
            <td><%= ctx.t('help.searchPosts.favCount') %></td>
        </tr>
        <tr>
            <td><code>note-count</code></td>
            <td><%= ctx.t('help.searchPosts.noteCount') %></td>
        </tr>
        <tr>
            <td><code>note-text</code></td>
            <td><%= ctx.t('help.searchPosts.noteText') %></td>
        </tr>
        <tr>
            <td><code>relation-count</code></td>
            <td><%= ctx.t('help.searchPosts.relationCount') %></td>
        </tr>
        <tr>
            <td><code>feature-count</code></td>
            <td><%= ctx.t('help.searchPosts.featureCount') %></td>
        </tr>
        <tr>
            <td><code>type</code></td>
            <td><%= ctx.t('help.searchPosts.type').replace('{value}', '<code>&lt;value&gt;</code>').replace('{image}', '<code>image</code>').replace('{animation}', '<code>animation</code>').replace('{animated}', '<code>animated</code>').replace('{anim}', '<code>anim</code>').replace('{flash}', '<code>flash</code>').replace('{swf}', '<code>swf</code>').replace('{video}', '<code>video</code>').replace('{webm}', '<code>webm</code>') %></td>
        </tr>
        <tr>
            <td><code>flag</code></td>
            <td><%= ctx.t('help.searchPosts.flag').replace('{value}', '<code>&lt;value&gt;</code>').replace('{loop}', '<code>loop</code>').replace('{sound}', '<code>sound</code>') %></td>
        </tr>
        <tr>
            <td><code>sha1</code></td>
            <td><%= ctx.t('help.searchPosts.sha1') %></td>
        </tr>
        <tr>
            <td><code>md5</code></td>
            <td><%= ctx.t('help.searchPosts.md5') %></td>
        </tr>
        <tr>
            <td><code>content-checksum</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>sha1</code>') %></td>
        </tr>
        <tr>
            <td><code>file-size</code></td>
            <td><%= ctx.t('help.searchPosts.fileSize') %></td>
        </tr>
        <tr>
            <td><code>image-width</code></td>
            <td><%= ctx.t('help.searchPosts.imageWidth') %></td>
        </tr>
        <tr>
            <td><code>image-height</code></td>
            <td><%= ctx.t('help.searchPosts.imageHeight') %></td>
        </tr>
        <tr>
            <td><code>image-area</code></td>
            <td><%= ctx.t('help.searchPosts.imageArea') %></td>
        </tr>
        <tr>
            <td><code>image-aspect-ratio</code></td>
            <td><%= ctx.t('help.searchPosts.aspectRatio') %></td>
        </tr>
        <tr>
            <td><code>image-ar</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>image-aspect-ratio</code>') %></td>
        </tr>
        <tr>
            <td><code>width</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>image-width</code>') %></td>
        </tr>
        <tr>
            <td><code>height</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>image-height</code>') %></td>
        </tr>
        <tr>
            <td><code>area</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>image-area</code>') %></td>
        </tr>
        <tr>
            <td><code>aspect-ratio</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>image-aspect-ratio</code>') %></td>
        </tr>
        <tr>
            <td><code>ar</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>image-aspect-ratio</code>') %></td>
        </tr>
        <tr>
            <td><code>creation-date</code></td>
            <td><%= ctx.t('help.searchPosts.creationDate') %></td>
        </tr>
        <tr>
            <td><code>creation-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>creation-date</code>') %></td>
        </tr>
        <tr>
            <td><code>date</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>creation-date</code>') %></td>
        </tr>
        <tr>
            <td><code>time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>creation-date</code>') %></td>
        </tr>
        <tr>
            <td><code>last-edit-date</code></td>
            <td><%= ctx.t('help.searchPosts.lastEditDate') %></td>
        </tr>
        <tr>
            <td><code>last-edit-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>last-edit-date</code>') %></td>
        </tr>
        <tr>
            <td><code>edit-date</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>last-edit-date</code>') %></td>
        </tr>
        <tr>
            <td><code>edit-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>last-edit-date</code>') %></td>
        </tr>
        <tr>
            <td><code>comment-date</code></td>
            <td><%= ctx.t('help.searchPosts.commentDate') %></td>
        </tr>
        <tr>
            <td><code>comment-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>comment-date</code>') %></td>
        </tr>
        <tr>
            <td><code>fav-date</code></td>
            <td><%= ctx.t('help.searchPosts.favDate') %></td>
        </tr>
        <tr>
            <td><code>fav-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>fav-date</code>') %></td>
        </tr>
        <tr>
            <td><code>feature-date</code></td>
            <td><%= ctx.t('help.searchPosts.featureDate') %></td>
        </tr>
        <tr>
            <td><code>feature-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>feature-time</code>') %></td>
        </tr>
        <tr>
            <td><code>safety</code></td>
            <td><%= ctx.t('help.searchPosts.safety') %></td>
        </tr>
        <tr>
            <td><code>rating</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>safety</code>') %></td>
        </tr>
    </tbody>
</table>

<p><strong><%= ctx.t('help.search.sortTokens') %></strong></p>

<table>
    <tbody>
        <tr>
            <td><code>random</code></td>
            <td><%= ctx.t('help.searchPosts.sortRandom') %></td>
        </tr>
        <tr>
            <td><code>id</code></td>
            <td><%= ctx.t('help.searchPosts.sortId') %></td>
        </tr>
        <tr>
            <td><code>score</code></td>
            <td><%= ctx.t('help.searchPosts.sortScore') %></td>
        </tr>
        <tr>
            <td><code>tag-count</code></td>
            <td><%= ctx.t('help.searchPosts.sortTagCount') %></td>
        </tr>
        <tr>
            <td><code>comment-count</code></td>
            <td><%= ctx.t('help.searchPosts.sortCommentCount') %></td>
        </tr>
        <tr>
            <td><code>fav-count</code></td>
            <td><%= ctx.t('help.searchPosts.sortFavCount') %></td>
        </tr>
        <tr>
            <td><code>note-count</code></td>
            <td><%= ctx.t('help.searchPosts.sortNoteCount') %></td>
        </tr>
        <tr>
            <td><code>relation-count</code></td>
            <td><%= ctx.t('help.searchPosts.sortRelationCount') %></td>
        </tr>
        <tr>
            <td><code>feature-count</code></td>
            <td><%= ctx.t('help.searchPosts.sortFeatureCount') %></td>
        </tr>
        <tr>
            <td><code>file-size</code></td>
            <td><%= ctx.t('help.searchPosts.sortFileSize') %></td>
        </tr>
        <tr>
            <td><code>image-width</code></td>
            <td><%= ctx.t('help.searchPosts.sortImageWidth') %></td>
        </tr>
        <tr>
            <td><code>image-height</code></td>
            <td><%= ctx.t('help.searchPosts.sortImageHeight') %></td>
        </tr>
        <tr>
            <td><code>image-area</code></td>
            <td><%= ctx.t('help.searchPosts.sortImageArea') %></td>
        </tr>
        <tr>
            <td><code>width</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>image-width</code>') %></td>
        </tr>
        <tr>
            <td><code>height</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>image-height</code>') %></td>
        </tr>
        <tr>
            <td><code>area</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>image-area</code>') %></td>
        </tr>
        <tr>
            <td><code>creation-date</code></td>
            <td><%= ctx.t('help.searchPosts.sortCreationDate').replace('{id}', '<code>id</code>') %></td>
        </tr>
        <tr>
            <td><code>creation-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>creation-date</code>') %></td>
        </tr>
        <tr>
            <td><code>date</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>creation-date</code>') %></td>
        </tr>
        <tr>
            <td><code>time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>creation-date</code>') %></td>
        </tr>
        <tr>
            <td><code>last-edit-date</code></td>
            <td><%= ctx.t('help.searchPosts.sortLastEditDate').replace('{creationDate}', '<code>creation-date</code>') %></td>
        </tr>
        <tr>
            <td><code>last-edit-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>last-edit-date</code>') %></td>
        </tr>
        <tr>
            <td><code>edit-date</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>last-edit-date</code>') %></td>
        </tr>
        <tr>
            <td><code>edit-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>last-edit-date</code>') %></td>
        </tr>
        <tr>
            <td><code>comment-date</code></td>
            <td><%= ctx.t('help.searchPosts.sortCommentDate') %></td>
        </tr>
        <tr>
            <td><code>comment-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>comment-date</code>') %></td>
        </tr>
        <tr>
            <td><code>fav-date</code></td>
            <td><%= ctx.t('help.searchPosts.sortFavDate') %></td>
        </tr>
        <tr>
            <td><code>fav-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>fav-date</code>') %></td>
        </tr>
        <tr>
            <td><code>feature-date</code></td>
            <td><%= ctx.t('help.searchPosts.sortFeatureDate') %></td>
        </tr>
        <tr>
            <td><code>feature-time</code></td>
            <td><%= ctx.t('help.search.aliasOf').replace('{token}', '<code>feature-time</code>') %></td>
        </tr>
    </tbody>
</table>

<p><strong><%= ctx.t('help.search.specialTokens') %></strong></p>

<table>
    <tbody>
        <tr>
            <td><code>liked</code></td>
            <td><%= ctx.t('help.searchPosts.specialLiked') %></td>
        </tr>
        <tr>
            <td><code>disliked</code></td>
            <td><%= ctx.t('help.searchPosts.specialDisliked') %></td>
        </tr>
        <tr>
            <td><code>fav</code></td>
            <td><%= ctx.t('help.searchPosts.specialFav') %></td>
        </tr>
        <tr>
            <td><code>tumbleweed</code></td>
            <td><%= ctx.t('help.searchPosts.specialTumbleweed') %></td>
        </tr>
    </tbody>
</table>
