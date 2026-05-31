"use strict";

const api = require("../api.js");
const uri = require("../util/uri.js");
const AbstractList = require("./abstract_list.js");
const FavoriteGroup = require("./favorite_group.js");

class FavoriteGroupList extends AbstractList {
    static get() {
        return api
            .get(uri.formatApiLink("favorite-groups"))
            .then((response) => {
                return Promise.resolve(
                    Object.assign({}, response, {
                        results: FavoriteGroupList.fromResponse(
                            response.results
                        ),
                    })
                );
            });
    }
}

FavoriteGroupList._itemClass = FavoriteGroup;
FavoriteGroupList._itemName = "favoriteGroup";

module.exports = FavoriteGroupList;
