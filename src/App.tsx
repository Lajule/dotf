import {useState, useEffect} from 'react';
import Mustache from 'mustache';
import './App.css';
import {Code} from './Code';
import {Form} from './Form';
import {Tree} from './Tree';
import {Config} from './types';

const sampleCode = '{"foo": "{{bar}}"}';

function App() {
  const [config, setConfig] = useState<Config>();

  const fetchDotfiles = async () => {
    const response = await fetch('config.json');
    setConfig(await response.json());
  }

  useEffect(() => {
    fetchDotfiles();
  }, []);

  return (
    <div className="app">
      <div className="sidebar">
        {config !== undefined && <Tree dotfiles={config.dotfiles} />}
      </div>
      <div className="body">
        <div className="variables">
          {config !== undefined && <Form variables={config.variables} />}
        </div>
        <div className="file">
          <div className="template">
            <textarea defaultValue="It was a dark and stormy night..."></textarea>
          </div>
          <div className="preview">
            <Code content={Mustache.render(sampleCode, {bar: "foo bar"})} />
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
