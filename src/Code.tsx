import {FC, useEffect} from 'react';
import hljs from 'highlight.js';
import bash from 'highlight.js/lib/languages/bash';
import json from 'highlight.js/lib/languages/json';
import yaml from 'highlight.js/lib/languages/yaml';
import 'highlight.js/styles/base16/solarized-light.css';

hljs.registerLanguage('bash', bash);
hljs.registerLanguage('json', json);
hljs.registerLanguage('yaml', yaml);
hljs.configure({ignoreUnescapedHTML: true});

interface CodeProps {
  content: string;
}

export const Code: FC<CodeProps> = ({content}) => {
  useEffect(() => {
    hljs.highlightAll();
  }, []);

  return (
    <pre className="codeblock">
      <code>{content.trim()}</code>
    </pre>
  );
};
