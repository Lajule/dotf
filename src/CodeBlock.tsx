import {FC, useEffect, useRef} from 'react';
import hljs from 'highlight.js';
import bash from 'highlight.js/lib/languages/bash';
import json from 'highlight.js/lib/languages/json';
import yaml from 'highlight.js/lib/languages/yaml';
import 'highlight.js/styles/base16/solarized-light.css';

hljs.registerLanguage('bash', bash);
hljs.registerLanguage('json', json);
hljs.registerLanguage('yaml', yaml);
hljs.configure({ignoreUnescapedHTML: true});

interface CodeBlockProps {
  content: string;
}

export const CodeBlock: FC<CodeBlockProps> = ({content}) => {
  const ref = useRef<HTMLPreElement>(null);

  useEffect(() => {
    if (ref.current) {
      hljs.highlightElement(ref.current);
    }
  }, []);

  return (
    <pre ref={ref} className="codeblock">
      <code>{content.trim()}</code>
    </pre>
  );
};
