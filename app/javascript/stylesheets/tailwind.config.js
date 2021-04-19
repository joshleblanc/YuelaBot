const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  mode: 'jit',
  plugins: [
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/line-clamp'),
    require('@tailwindcss/typography'),
  ],
  purge: {
    enabled: ["production", "staging"].includes(process.env.NODE_ENV),
    content: [
      './**/*.html.erb',
      './app/components/**/*.rb',
      './app/helpers/**/*.rb',
      './app/javascript/**/*.js',
    ],
  },
  theme: {
    extend: {
      colors: {
        'tertiary': {
          '50': '#fafafd',
          '100': '#f5f4fb',
          '200': '#e5e5f6',
          '300': '#d5d5f1',
          '400': '#b6b5e6',
          '500': '#9695db',
          '600': '#8786c5',
          '700': '#7170a4',
          '800': '#5a5983',
          '900': '#4a496b'
        },
        'danger': {
          '50': '#fff2f2',
          '100': '#ffe6e6',
          '200': '#febfbf',
          '300': '#fd9999',
          '400': '#fc4d4d',
          '500': '#fa0000',
          '600': '#e10000',
          '700': '#bc0000',
          '800': '#960000',
          '900': '#7b0000'
        },
        'secondary': {
          '50': '#f4fdf6',
          '100': '#e9fbed',
          '200': '#c8f4d1',
          '300': '#a7edb5',
          '400': '#64e07e',
          '500': '#22d346',
          '600': '#1fbe3f',
          '700': '#1a9e35',
          '800': '#147f2a',
          '900': '#116722'
        },
        'primary': {
          '50': '#fdf5fc',
          '100': '#fceaf9',
          '200': '#f6cbef',
          '300': '#f1abe5',
          '400': '#e76dd2',
          '500': '#dc2ebf',
          '600': '#c629ac',
          '700': '#a5238f',
          '800': '#841c73',
          '900': '#6c175e'
        },
        "code-400": "#fefcf9",
        "code-600": "#3c455b",
      },
    },
    fontFamily: {
      sans: ['Inter', ...defaultTheme.fontFamily.sans],
    },
  },
  variants: {
    borderWidth: ['responsive', 'last', 'hover', 'focus'],
  },
}
