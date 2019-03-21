const path = require('path');
const webpack = require('webpack');
const merge = require('webpack-merge');
const elmMinify = require('elm-minify');

const CopyWebpackPlugin = require('copy-webpack-plugin');
const HTMLWebpackPlugin = require('html-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

var MODE = process.env.npm_lifecycle_event === 'prod' ? 'production' : 'development';
var withDebug = !process.env['npm_config_nodebug'];
console.log('\x1b[36m%s\x1b[0m', `** Compile: mode "${MODE}", withDebug: ${withDebug}\n`);

var common = {
  mode: MODE,
  entry: './src/index.ts',
  output: {
    path: path.join(__dirname, 'dist'),
    publicPath: '/',
    filename: MODE == 'production' ? '[name]-[hash].js' : 'index.js',
  },
  plugins: [
    new HTMLWebpackPlugin({
      template: 'src/index.html',
      inject: 'body',
    }),
  ],
  resolve: {
    modules: [path.join(__dirname, 'src'), 'node_modules'],
    extensions: ['.js', '.ts', '.elm', '.scss', '.png'],
  },
  module: {
    rules: [
      {
        test: /\.ts$/,
        exclude: /node_modules/,
        use: {
          loader: 'ts-loader',
        },
      },
      {
        test: /\.scss$/,
        exclude: [/elm-stuff/, /node_modules/],
        loaders: ['style-loader', 'css-loader?url=false', 'sass-loader'],
      },
      {
        test: /\.css$/,
        exclude: [/elm-stuff/, /node_modules/],
        loaders: ['style-loader', 'css-loader?url=false'],
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'url-loader',
        options: {
          limit: 10000,
          mimetype: 'application/font-woff',
        },
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'file-loader',
      },
      {
        test: /\.(jpe?g|png|gif|svg)$/i,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'file-loader',
      },
    ],
  },
};

if (MODE === 'development') {
  module.exports = merge(common, {
    plugins: [new webpack.NamedModulesPlugin(), new webpack.NoEmitOnErrorsPlugin()],
    module: {
      rules: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: [
            { loader: 'elm-hot-webpack-loader' },
            {
              loader: 'elm-webpack-loader',
              options: {
                debug: withDebug,
                forceWatch: true,
              },
            },
          ],
        },
      ],
    },
    devServer: {
      inline: true,
      stats: 'errors-only',
      contentBase: path.join(__dirname, 'src/assets'),
      historyApiFallback: true,
    },
  });
}
if (MODE === 'production') {
  module.exports = merge(common, {
    plugins: [
      new elmMinify.WebpackPlugin(),
      new CleanWebpackPlugin({
        root: __dirname,
        exclude: [],
        verbose: true,
        dry: false,
      }),
      new CopyWebpackPlugin([
        {
          from: 'src/assets',
        },
      ]),
      new MiniCssExtractPlugin({
        filename: '[name]-[hash].css',
      }),
    ],
    module: {
      rules: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: {
            loader: 'elm-webpack-loader',
            options: {
              optimize: true,
            },
          },
        },
        {
          test: /\.css$/,
          exclude: [/elm-stuff/, /node_modules/],
          loaders: [MiniCssExtractPlugin.loader, 'css-loader?url=false'],
        },
        {
          test: /\.scss$/,
          exclude: [/elm-stuff/, /node_modules/],
          loaders: [MiniCssExtractPlugin.loader, 'css-loader?url=false', 'sass-loader'],
        },
      ],
    },
  });
}
