module.exports = (request, options) => request === '@personal-library/react-native-components'
  ? options.defaultResolver(request, { ...options, conditions: ['import', 'default'] })
  : options.defaultResolver(request, options);
