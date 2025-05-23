// Populate the sidebar
//
// This is a script, and not included directly in the page, to control the total size of the book.
// The TOC contains an entry for each page, so if each page includes a copy of the TOC,
// the total size of the page becomes O(n**2).
class MDBookSidebarScrollbox extends HTMLElement {
    constructor() {
        super();
    }
    connectedCallback() {
        this.innerHTML = '<ol class="chapter"><li class="chapter-item expanded "><a href="welcome.html"><strong aria-hidden="true">1.</strong> Введение</a></li><li class="chapter-item expanded "><a href="basic_macro.html"><strong aria-hidden="true">2.</strong> Макросы сравнения</a></li><li class="chapter-item expanded "><a href="Macros/intro.html"><strong aria-hidden="true">3.</strong> Детальное знакомство c макросами</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="Macros/macro_test.html"><strong aria-hidden="true">3.1.</strong> @Test</a></li><li class="chapter-item expanded "><a href="Macros/macro_suite.html"><strong aria-hidden="true">3.2.</strong> @Suite</a></li><li class="chapter-item expanded "><a href="Macros/macro_tag.html"><strong aria-hidden="true">3.3.</strong> @Tag</a></li><li class="chapter-item expanded "><a href="Macros/secret_macro.html"><strong aria-hidden="true">3.4.</strong> Скрытый макрос</a></li></ol></li><li class="chapter-item expanded "><a href="protocol_Trait.html"><strong aria-hidden="true">4.</strong> Трейты</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="Traits/CommentTrait.html"><strong aria-hidden="true">4.1.</strong> Comment</a></li><li class="chapter-item expanded "><a href="Traits/ConditionTrait.html"><strong aria-hidden="true">4.2.</strong> Condition</a></li><li class="chapter-item expanded "><a href="Traits/TimeLimitTrait.html"><strong aria-hidden="true">4.3.</strong> TimeLimit</a></li><li class="chapter-item expanded "><a href="Traits/BugTrait.html"><strong aria-hidden="true">4.4.</strong> Bug</a></li><li class="chapter-item expanded "><a href="Traits/IssueTrait.html"><strong aria-hidden="true">4.5.</strong> Issue</a></li><li class="chapter-item expanded "><a href="Traits/ParallelizationTrait.html"><strong aria-hidden="true">4.6.</strong> Parallelization</a></li><li class="chapter-item expanded "><a href="Traits/TagTrait.html"><strong aria-hidden="true">4.7.</strong> Tag</a></li></ol></li><li class="chapter-item expanded "><a href="Traits/OwnTrait.html"><strong aria-hidden="true">5.</strong> Добавляем собственный трейт</a></li><li class="chapter-item expanded "><a href="best_practice_short.html"><strong aria-hidden="true">6.</strong> Best practice</a></li><li class="chapter-item expanded "><a href="runner.html"><strong aria-hidden="true">7.</strong> Кто управляет тестами</a></li><li class="chapter-item expanded "><a href="compare_xctest_and_modern_aproach.html"><strong aria-hidden="true">8.</strong> XCTest или Swift Testing ?</a></li><li class="chapter-item expanded "><a href="xcode_meta.html"><strong aria-hidden="true">9.</strong> Мета информация и обозначения</a></li><li class="chapter-item expanded "><a href="when_and_why.html"><strong aria-hidden="true">10.</strong> Почему и когда ?</a></li><li class="chapter-item expanded "><a href="in_the_end.html"><strong aria-hidden="true">11.</strong> Вместо прощания</a></li></ol>';
        // Set the current, active page, and reveal it if it's hidden
        let current_page = document.location.href.toString().split("#")[0];
        if (current_page.endsWith("/")) {
            current_page += "index.html";
        }
        var links = Array.prototype.slice.call(this.querySelectorAll("a"));
        var l = links.length;
        for (var i = 0; i < l; ++i) {
            var link = links[i];
            var href = link.getAttribute("href");
            if (href && !href.startsWith("#") && !/^(?:[a-z+]+:)?\/\//.test(href)) {
                link.href = path_to_root + href;
            }
            // The "index" page is supposed to alias the first chapter in the book.
            if (link.href === current_page || (i === 0 && path_to_root === "" && current_page.endsWith("/index.html"))) {
                link.classList.add("active");
                var parent = link.parentElement;
                if (parent && parent.classList.contains("chapter-item")) {
                    parent.classList.add("expanded");
                }
                while (parent) {
                    if (parent.tagName === "LI" && parent.previousElementSibling) {
                        if (parent.previousElementSibling.classList.contains("chapter-item")) {
                            parent.previousElementSibling.classList.add("expanded");
                        }
                    }
                    parent = parent.parentElement;
                }
            }
        }
        // Track and set sidebar scroll position
        this.addEventListener('click', function(e) {
            if (e.target.tagName === 'A') {
                sessionStorage.setItem('sidebar-scroll', this.scrollTop);
            }
        }, { passive: true });
        var sidebarScrollTop = sessionStorage.getItem('sidebar-scroll');
        sessionStorage.removeItem('sidebar-scroll');
        if (sidebarScrollTop) {
            // preserve sidebar scroll position when navigating via links within sidebar
            this.scrollTop = sidebarScrollTop;
        } else {
            // scroll sidebar to current active section when navigating via "next/previous chapter" buttons
            var activeSection = document.querySelector('#sidebar .active');
            if (activeSection) {
                activeSection.scrollIntoView({ block: 'center' });
            }
        }
        // Toggle buttons
        var sidebarAnchorToggles = document.querySelectorAll('#sidebar a.toggle');
        function toggleSection(ev) {
            ev.currentTarget.parentElement.classList.toggle('expanded');
        }
        Array.from(sidebarAnchorToggles).forEach(function (el) {
            el.addEventListener('click', toggleSection);
        });
    }
}
window.customElements.define("mdbook-sidebar-scrollbox", MDBookSidebarScrollbox);
