const { webpackConfig, merge } = require('@rails/webpacker')
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
webpackConfig.plugins = webpackConfig.plugins.filter(p => p.constructor.name != 'MiniCssExtractPlugin')

const customConfig = {
  devtool: 'eval-cheap-module-source-map',
  plugins: [
    new MiniCssExtractPlugin({
      filename: 'css/[name]-[contenthash:8].css',
      chunkFilename: 'css/[id]-[contenthash:8].css'
    })
  ],
  resolve: {
    extensions: ['.css']
  }
}

module.exports = merge(webpackConfig, customConfig)
