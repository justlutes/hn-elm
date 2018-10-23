import webpack from "webpack";
import HtmlWebpackPlugin from "html-webpack-plugin";

const isProd = process.env.NODE_ENV !== "dev";

const conditionalPlugins = isProd
  ? [new webpack.optimize.ModuleConcatenationPlugin()]
  : [new webpack.HotModuleReplacementPlugin()];

const entry = [
  require.resolve("webpack/hot/dev-server"),
  path.resolve("./src/js/index.js")
];

export default {
  entry,
  devtool: false,
  output: {
    publicPath: "/",
    chunkFilename: "static/[name].bundle.js",
    path: path.resolve("./dist"),
    filename: "static/main.[hash:8].js"
  },

  plugins: [
    ...conditionalPlugins,
    new HtmlWebpackPlugin({
      inject: true,
      template: path.resolve("./public/index.html")
    })
  ],

  resolve: {
    modules: ["node_modules"],
    extensions: [".ts", ".elm"]
  },

  module: {
    rules: [
      {
        test: /\.ts$/,
        user: {
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
