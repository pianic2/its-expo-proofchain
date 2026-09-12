module.exports = (request, options) => {
  if (request === '@personal-library/react-native-components') {
    return options.defaultResolver(request, { ...options, conditions: ['import', 'default'] });
  }
  return options.defaultResolver(request, options);
};
