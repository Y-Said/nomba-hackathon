var splitLongText = (String path) {
  var pathItems = <String>[];
  // Split string into 15 chars per line
  var startOffset = 0;
  var endOffset = 13;
  const noOFChars = 13;

  while (true) {
    if (endOffset < path.length) {
      pathItems.add("${path.substring(startOffset, endOffset)} \n");
      startOffset += noOFChars;
      endOffset += noOFChars;
    } else {
      endOffset = (path.length - endOffset) + startOffset;
      pathItems.add("${path.substring(startOffset)} \n");
      break;
    }
  }

  return pathItems.join('');
};
