const webpack = require("webpack");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const path = require("path");
const fs = require("fs");

const isProd = process.env.NODE_ENV !== "dev";
const appRoot = fs.realpathSync(process.cwd());

const conditionalPlugins = isProd
  ? [new webpack.optimize.ModuleConcatenationPlugin()]
  : [new webpack.HotModuleReplacementPlugin()];

const entry = isProd
  ? [path.resolve(appRoot, "./src/js/index.ts")]
  : [
      require.resolve("webpack/hot/dev-server"),
      path.resolve(appRoot, "./src/js/index.ts")
    ];

module.exports = {
  entry,
  devtool: false,
  mode: "development",
  output: {
    publicPath: "/",
    chunkFilename: "static/[name].bundle.js",
    path: path.resolve(appRoot, "./dist"),
    filename: "static/main.[hash:8].js"
  },

  plugins: conditionalPlugins.concat([
    new HtmlWebpackPlugin({
      inject: true,
      template: path.resolve(appRoot, "./public/index.html")
    })
  ]),

  resolve: {
    modules: ["node_modules"],
    extensions: [".js", ".ts", ".elm"]
  },

  module: {
    rules: [
      {
        test: /\.ts$/,
        use: {
          loader: "ts-loader"
        }
      },
      {
        test: /\.elm$/,
        exclude: /(node_modules|elm-stuff)/,
        use: isProd
          ? [
              {
                loader: "elm-webpack-loader",
                options: {
                  cwd: __dirname,
                  runtimeOptions: "-A128m -H128m -n8m",
                  optimize: true
                }
              }
            ]
          : [
              { loader: "elm-hot-webpack-loader" },
              {
                loader: "elm-webpack-loader",
                options: {
                  cwd: __dirname,
                  runtimeOptions: "-A128m -H128m -n8m",
                  debug: true
                }
              }
            ]
      }
    ]
  }
};
