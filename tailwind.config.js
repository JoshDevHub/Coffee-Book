module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    screens: {
      'sm': '640px',
      'md': '850px',
      'lg': '1024px',
      'xl': '1280px',
      '2xl': '1536px'
    }
  }
}
