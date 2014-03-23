fs = require('fs')

# home page
exports.index = (req, res) ->
    fs.readdir 'recordings/', (err, _files) ->
        res.render 'home', {title: "ekwip", files: _files}