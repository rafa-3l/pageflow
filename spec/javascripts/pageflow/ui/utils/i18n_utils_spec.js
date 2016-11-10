describe('pageflow.i18nUtils', function() {
  support.useFakeTranslations({
    'some.key': 'Some text',
    'fallback': 'Fallback',
    'with.interpolation': 'Value %{value}',
    'html.key.without.suffix': '<div />',
    'html.key.with.suffix_html': '<div />'
  });

  describe('.findTranslation', function() {
    it('returns first present translation', function() {
      var result = pageflow.i18nUtils.findTranslation(
        ['not.there', 'some.key', 'fallback']
      );

      expect(result).to.eq('Some text');
    });

    it('falls back to defaultValue', function() {
      var result = pageflow.i18nUtils.findTranslation(
        ['not.there'],
        {defaultValue: 'Default'}
      );

      expect(result).to.eq('Default');
    });

    it('supports interpolations', function() {
      var result = pageflow.i18nUtils.findTranslation(
        ['with.interpolation'],
        {value: 'interpolated'}
      );

      expect(result).to.eq('Value interpolated');
    });

    it('does not escape html if html flag is not set', function() {
      var result = pageflow.i18nUtils.findTranslation(
        ['html.key.without.suffix']
      );

      expect(result).to.eq('<div />');
    });

    it('searches for keys ending in _html if flag is set', function() {
      var result = pageflow.i18nUtils.findTranslation(
        ['html.key.with.suffix'],
        {html: true}
      );

      expect(result).to.eq('<div />');
    });

    it('HTML-escapes translations the key of which does not end in _html, if html flag '+
       'is set', function() {
         var result = pageflow.i18nUtils.findTranslation(
           ['html.key.without.suffix'],
           {html: true}
         );

         expect(result).to.eq('&lt;div /&gt;');
       });

    it('does not escape default value if html flag is not set', function() {
      var result = pageflow.i18nUtils.findTranslation(
        ['not.there'],
        {defaultValue: '<div />'}
      );

      expect(result).to.eq('<div />');
    });

    it('does not escape default value if html flag is set', function() {
      var result = pageflow.i18nUtils.findTranslation(
        ['not.there'],
        {defaultValue: '<div />', html: true}
      );

      expect(result).to.eq('<div />');
    });
  });

  describe('.findKeyWithTranslation', function() {
    it('returns key withpresent translation', function() {
      var result = pageflow.i18nUtils.findKeyWithTranslation(
        ['not.there', 'some.key', 'fallback']
      );

      expect(result).to.eq('some.key');
    });

    it('falls back first key if all are missing', function() {
      var result = pageflow.i18nUtils.findKeyWithTranslation(
        ['not.there', 'also.not.there']
      );

      expect(result).to.eq('not.there');
    });
  });

  describe('.translationKeysWithSuffix', function() {
    it('returns array with additional suffixed key for each item', function() {
      var result = pageflow.i18nUtils.translationKeysWithSuffix(
        ['some.key', 'fallback'],
        'disabled'
      );

      expect(result).to.deep.eq(['some.key_disabled', 'some.key', 'fallback_disabled', 'fallback']);
    });
  });
});
