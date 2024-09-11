# frozen_string_literal: true

require "spec_helper"

RSpec.describe Milestoner::Renderers::Markdown do
  subject(:renderer) { described_class.new }

  describe "#call" do
    it "answers HTML" do
      html = renderer.call <<~CONTENT
        ## Test

        A [test](https://example.com) link.

        - One
        - Two
        - Three
      CONTENT

      expect(html).to eq(<<~PROOF)
        <h2>Test</h2>

        <p>A <a href="https://example.com">test</a> link.</p>

        <ul>
        <li>One</li>
        <li>Two</li>
        <li>Three</li>
        </ul>
      PROOF
    end

    it "answers HTML code block" do
      html = renderer.call <<~CONTENT
        ``` ruby
        1 + 1 = 2
        ```
      CONTENT

      expect(html).to eq(<<~PROOF.strip)
        <div class="highlight"><pre class="highlight ruby"><code><span class="mi">1</span> <span class="o">+</span> <span class="mi">1</span> <span class="o">=</span> <span class="mi">2</span>
        </code></pre></div>
      PROOF
    end

    it "answers HTML indented code block as a paragraph" do
      html = renderer.call "    1 + 1 = 2"
      expect(html).to eq("<p>1 + 1 = 2</p>\n")
    end

    it "answers HTML footnotes" do
      html = renderer.call <<~CONTENT
        This is a test.[^1]

        [^1]: A footnote.
      CONTENT

      expect(html).to eq(<<~PROOF)
        <p>This is a test.<sup id="fnref1"><a href="#fn1">1</a></sup></p>

        <div class="footnotes">
        <hr>
        <ol>

        <li id="fn1">
        <p>A footnote.&nbsp;<a href="#fnref1">&#8617;</a></p>
        </li>

        </ol>
        </div>
      PROOF
    end

    it "answers HTML highlight" do
      html = renderer.call "This is a ==highlight==."
      expect(html).to eq("<p>This is a <mark>highlight</mark>.</p>\n")
    end

    it "answers HTML table" do
      html = renderer.call <<~CONTENT
        | One| Two|
        |---:|----|
        |  1 |  2 |
      CONTENT

      expect(html).to eq(<<~PROOF)
        <table><thead>
        <tr>
        <th style="text-align: right">One</th>
        <th>Two</th>
        </tr>
        </thead><tbody>
        <tr>
        <td style="text-align: right">1</td>
        <td>2</td>
        </tr>
        </tbody></table>
      PROOF
    end
  end
end
