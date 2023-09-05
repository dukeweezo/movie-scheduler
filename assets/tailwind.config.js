// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/*_web.ex",
    "../lib/*_web/**/*.*ex"
  ],
  theme: {
    extend: {
      backgroundImage: {
        'day-to-night': 
          `linear-gradient(0deg, 
          hsl(246deg 100% 5%) 0%, 
          hsl(289deg 100% 17%) 13%,
          hsl(331deg 100% 28%) 25%,
          hsl(13deg 100% 39%) 37%,
          hsl(55deg 100% 50%) 50%,
          hsl(13deg 100% 39%) 63%,
          hsl(331deg 100% 28%) 75%,
          hsl(289deg 100% 17%) 87%,
          hsl(246deg 100% 5%) 100%
          )`,
        'asset':
          `linear-gradient(
          180deg,
          hsl(0deg 0% 14%) 0%,
          hsl(344deg 0% 14%) 11%,
          hsl(344deg 0% 14%) 22%,
          hsl(344deg 0% 15%) 33%,
          hsl(344deg 0% 15%) 44%,
          hsl(344deg 0% 15%) 56%,
          hsl(344deg 0% 15%) 67%,
          hsl(344deg 0% 15%) 78%,
          hsl(344deg 0% 16%) 89%,
          hsl(0deg 0% 16%) 100%
        )`
      },
      gridTemplateRows: {
        '11': 'repeat(11, 9.09090vh)',
        '49': 'repeat(49, 3rem)',
      },
      gridRow: {
        'span-3': 'span 3',
        'span-4': 'span 4',
        'span-5': 'span 5',
        'span-10': 'span 10 / span 10',
        'span-12': 'span 12 / span 12',
      },
      gridRowStart: {
        '8': '8',
        '9': '9',
        '10': '10',
        '11': '11',
      }
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    plugin(({addVariant}) => addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])),
    plugin(({addVariant}) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({addVariant}) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({addVariant}) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"]))
  ]
}