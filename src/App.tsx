import {useState, useEffect} from 'react';
import {saveAs} from 'file-saver';
import Mustache from 'mustache';
import JSZip from 'jszip';
import './App.css';
import {Code} from './Code';
import {Form} from './Form';
import {Files} from './Files';
import {Config} from './types';

const sampleCode = '{"foo": "{{bar}}"}';

function App() {
  const [config, setConfig] = useState<Config>();

  const fetchConfig = async () => {
    const response = await fetch('config.json');
    setConfig(await response.json());


    const zip = new JSZip();
    zip.file("Hello.txt", "Hello World\n");
    zip.generateAsync({type:"blob"}).then((content) => {
      saveAs(content, "archive.zip");
    });


  }

  useEffect(() => {
    fetchConfig();
  }, []);

  return (
    <div className="app">
      <div className="sidebar">
        {config !== undefined && <Files files={config.files} />}
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
