<script lang="ts">
  import { onMount } from 'svelte';
  import * as api from '$lib/api';
  import type { Hero, Skill, Project, Experience, Certification, Contact, BlogPost } from '$lib/types';

  let hero: Hero | null = null;
  let skills: Skill[] = [];
  let projects: Project[] = [];
  let experience: Experience[] = [];
  let certifications: Certification[] = [];
  let contact: Contact | null = null;
  let blogPosts: BlogPost[] = [];
  let loading = true;
  let error = '';

  onMount(async () => {
    try {
      // Fetch all data in parallel
      const [heroData, skillsData, projectsData, experienceData, certificationsData, contactData, blogData] = await Promise.all([
        api.getHero().catch(() => null),
        api.getSkills().catch(() => []),
        api.getProjects().catch(() => []),
        api.getExperience().catch(() => []),
        api.getCertifications().catch(() => []),
        api.getContact().catch(() => null),
        api.getBlogPosts().catch(() => [])
      ]);

      hero = heroData;
      skills = skillsData;
      projects = projectsData;
      experience = experienceData;
      certifications = certificationsData;
      contact = contactData;
      blogPosts = blogData;
    } catch (err) {
      error = err instanceof Error ? err.message : 'Failed to load data';
      console.error('Error loading data:', err);
    } finally {
      loading = false;
    }
  });
</script>

<div class="min-h-screen bg-black">
  {#if loading}
    <div class="flex items-center justify-center min-h-screen">
      <div class="text-xl text-primary-500">Loading...</div>
    </div>
  {:else if error}
    <div class="flex items-center justify-center min-h-screen">
      <div class="text-red-500">Error: {error}</div>
    </div>
  {:else}
    <!-- Navigation -->
    <nav class="fixed top-0 left-0 right-0 z-50 bg-black/90 backdrop-blur-lg border-b border-zinc-800/50">
      <div class="container mx-auto px-6 lg:px-8 py-4 flex items-center justify-between">
        <div class="flex items-center gap-2 group cursor-pointer">
          <span class="text-primary-500 text-2xl group-hover:scale-110 transition-transform">⚡</span>
          <span class="text-white font-bold text-xl tracking-tight">PORTFOLIO</span>
        </div>
        <div class="hidden md:flex items-center gap-8 lg:gap-10">
          <a href="#home" class="text-sm font-medium text-gray-400 hover:text-primary-500 transition-colors relative group">
            Home
            <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary-500 group-hover:w-full transition-all duration-300"></span>
          </a>
          <a href="#skills" class="text-sm font-medium text-gray-400 hover:text-primary-500 transition-colors relative group">
            Skills
            <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary-500 group-hover:w-full transition-all duration-300"></span>
          </a>
          <a href="#projects" class="text-sm font-medium text-gray-400 hover:text-primary-500 transition-colors relative group">
            Projects
            <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary-500 group-hover:w-full transition-all duration-300"></span>
          </a>
          <a href="#experience" class="text-sm font-medium text-gray-400 hover:text-primary-500 transition-colors relative group">
            Experience
            <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary-500 group-hover:w-full transition-all duration-300"></span>
          </a>
          <a href="#certifications" class="text-sm font-medium text-gray-400 hover:text-primary-500 transition-colors relative group">
            Certifications
            <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary-500 group-hover:w-full transition-all duration-300"></span>
          </a>
          <a href="#contact" class="px-4 py-2 bg-primary-500 text-black text-sm font-semibold rounded-lg hover:bg-primary-400 transition-all hover:scale-105">
            Contact
          </a>
        </div>
        <!-- Mobile Menu Button -->
        <button class="md:hidden text-gray-400 hover:text-primary-500">
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/>
          </svg>
        </button>
      </div>
    </nav>

    <!-- Hero Section -->
    {#if hero}
      <section id="home" class="relative min-h-screen bg-black text-white pt-20 pb-12 md:pt-24 md:pb-16 flex items-center overflow-hidden">
        <!-- Animated Background Elements -->
        <div class="absolute inset-0 overflow-hidden pointer-events-none">
          <div class="absolute top-1/4 -left-48 w-96 h-96 bg-primary-500/10 rounded-full blur-3xl animate-pulse"></div>
          <div class="absolute bottom-1/4 -right-48 w-96 h-96 bg-primary-500/10 rounded-full blur-3xl animate-pulse" style="animation-delay: 2s;"></div>
          <div class="absolute inset-0 bg-[linear-gradient(rgba(34,197,94,0.03)_1px,transparent_1px),linear-gradient(90deg,rgba(34,197,94,0.03)_1px,transparent_1px)] bg-[size:100px_100px] [mask-image:radial-gradient(ellipse_80%_50%_at_50%_50%,black,transparent)]"></div>
        </div>

        <div class="w-full px-6 lg:px-12 xl:px-16 relative z-10">
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 lg:gap-16 items-center">
            <!-- Left Content -->
            <div class="space-y-6 lg:space-y-8 order-2 lg:order-1">
              <!-- Available Badge -->
              <div class="inline-flex items-center gap-2 px-4 py-2.5 bg-zinc-900/80 backdrop-blur-sm border border-zinc-800/50 rounded-full shadow-lg hover:border-primary-500/50 transition-all group">
                <span class="relative flex h-2.5 w-2.5">
                  <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-primary-500 opacity-75"></span>
                  <span class="relative inline-flex rounded-full h-2.5 w-2.5 bg-primary-500"></span>
                </span>
                <span class="text-sm text-gray-300 group-hover:text-primary-400 transition-colors">Available for opportunities</span>
              </div>

              <!-- Name -->
              <div class="space-y-4">
                <h1 class="text-5xl sm:text-6xl md:text-7xl lg:text-8xl font-bold text-white leading-[1.1] tracking-tight">
                  <span class="inline-block hover:text-primary-500 transition-colors duration-300">
                    {hero.name.split(' ')[0]}
                  </span>
                  <br/>
                  <span class="inline-block hover:text-primary-500 transition-colors duration-300">
                    {hero.name.split(' ').slice(1).join(' ')}
                  </span>
                </h1>
              </div>

              <!-- Tagline -->
              <div class="relative">
                <p class="text-xl sm:text-2xl md:text-3xl text-primary-500 font-semibold leading-relaxed">
                  {hero.tagline}
                </p>
                <div class="absolute -left-4 top-0 bottom-0 w-1 bg-gradient-to-b from-primary-500 to-transparent rounded-full"></div>
              </div>

              <!-- Description -->
              <p class="text-base sm:text-lg text-gray-400 leading-relaxed max-w-xl">
                {hero.description}
              </p>

              <!-- Action Buttons -->
              <div class="flex flex-col sm:flex-row flex-wrap gap-4 pt-4">
                <a href="#projects" class="group inline-flex items-center justify-center gap-2 px-8 py-4 bg-primary-500 text-black font-semibold rounded-lg hover:bg-primary-400 transition-all hover:scale-105 hover:shadow-lg hover:shadow-primary-500/50">
                  <span>View Projects</span>
                  <svg class="w-5 h-5 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"/>
                  </svg>
                </a>
                {#if hero.resume_url}
                  <a href={hero.resume_url} target="_blank" rel="noopener" class="group inline-flex items-center justify-center gap-2 px-8 py-4 border-2 border-zinc-800 text-gray-300 font-semibold rounded-lg hover:bg-zinc-900 hover:border-primary-500 transition-all hover:scale-105">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                    </svg>
                    <span>Download Resume</span>
                  </a>
                {/if}
              </div>

              <!-- Social Links -->
              <div class="flex gap-4 pt-6">
                {#if hero.github_url}
                  <a href={hero.github_url} target="_blank" rel="noopener" class="group relative p-3 bg-zinc-900/50 border border-zinc-800 rounded-lg text-gray-400 hover:text-primary-500 hover:border-primary-500/50 transition-all hover:scale-110">
                    <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/>
                    </svg>
                    <span class="absolute -top-8 left-1/2 -translate-x-1/2 px-2 py-1 bg-zinc-900 text-xs text-gray-300 rounded opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap">GitHub</span>
                  </a>
                {/if}
                {#if hero.linkedin_url}
                  <a href={hero.linkedin_url} target="_blank" rel="noopener" class="group relative p-3 bg-zinc-900/50 border border-zinc-800 rounded-lg text-gray-400 hover:text-primary-500 hover:border-primary-500/50 transition-all hover:scale-110">
                    <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/>
                    </svg>
                    <span class="absolute -top-8 left-1/2 -translate-x-1/2 px-2 py-1 bg-zinc-900 text-xs text-gray-300 rounded opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap">LinkedIn</span>
                  </a>
                {/if}
                {#if hero.twitter_url}
                  <a href={hero.twitter_url} target="_blank" rel="noopener" class="group relative p-3 bg-zinc-900/50 border border-zinc-800 rounded-lg text-gray-400 hover:text-primary-500 hover:border-primary-500/50 transition-all hover:scale-110">
                    <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z"/>
                    </svg>
                    <span class="absolute -top-8 left-1/2 -translate-x-1/2 px-2 py-1 bg-zinc-900 text-xs text-gray-300 rounded opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap">Twitter</span>
                  </a>
                {/if}
              </div>
            </div>

            <!-- Right Content - Video/Image -->
            <div class="relative order-1 lg:order-2">
              {#if hero.media_type === 'video' && hero.video_url}
                <div class="relative group">
                  <!-- Glow Effect -->
                  <div class="absolute -inset-1 bg-gradient-to-r from-primary-500 to-primary-600 rounded-2xl blur-2xl opacity-20 group-hover:opacity-30 transition-opacity"></div>
                  
                  <!-- Video Container -->
                  <div class="relative rounded-2xl overflow-hidden shadow-2xl border border-zinc-800 bg-zinc-900/50 backdrop-blur-sm p-2 transform transition-transform group-hover:scale-[1.02]">
                    
                    <!-- Video Content -->
                    <div class="bg-white rounded-lg overflow-hidden shadow-inner">
                      <video 
                        autoplay 
                        loop 
                        muted 
                        playsinline
                        class="w-full h-auto"
                      >
                        <source src={hero.video_url} type="video/mp4" />
                      </video>
                    </div>
                  </div>
                </div>
              {:else if hero.media_type === 'image' && hero.image_url}
                <div class="relative group">
                  <!-- Glow Effect -->
                  <div class="absolute -inset-1 bg-gradient-to-r from-primary-500 to-primary-600 rounded-2xl blur-2xl opacity-20 group-hover:opacity-30 transition-opacity"></div>
                  
                  <!-- Image Container -->
                  <div class="relative rounded-2xl overflow-hidden shadow-2xl border border-zinc-800 bg-zinc-900/50 backdrop-blur-sm p-2 transform transition-transform group-hover:scale-[1.02]">
                    
                    <!-- Image Content -->
                    <div class="bg-white rounded-lg overflow-hidden shadow-inner">
                      <img 
                        src={hero.image_url} 
                        alt={hero.name}
                        class="w-full h-auto"
                      />
                    </div>
                  </div>
                </div>
              {/if}
            </div>
          </div>
        </div>
      </section>
    {/if}

    <!-- Skills Section -->
    {#if skills.length > 0}
      <section id="skills" class="py-16 md:py-24 bg-black">
        <div class="container mx-auto px-4 max-w-6xl">
          <h2 class="section-title text-center mb-12">Skills</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {#each skills as skill}
              <div class="card">
                <h3 class="text-xl font-semibold mb-2 text-white">{skill.name}</h3>
                <p class="text-gray-400 mb-3">{skill.category}</p>
                <div class="w-full bg-zinc-900 rounded-full h-2.5">
                  <div class="bg-primary-500 h-2.5 rounded-full transition-all duration-500" style="width: {skill.proficiency}%"></div>
                </div>
                <p class="text-sm text-gray-500 mt-2">{skill.proficiency}%</p>
              </div>
            {/each}
          </div>
        </div>
      </section>
    {/if}

    <!-- Projects Section -->
    {#if projects.length > 0}
      <section id="projects" class="py-16 md:py-24 bg-zinc-950">
        <div class="container mx-auto px-4 max-w-6xl">
          <h2 class="section-title text-center mb-12">Projects</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {#each projects as project}
              <div class="card group">
                {#if project.featured}
                  <span class="inline-block bg-primary-500 text-black text-xs px-2 py-1 rounded mb-2 font-semibold">Featured</span>
                {/if}
                <h3 class="text-xl font-semibold mb-2 text-white group-hover:text-primary-400 transition-colors">{project.title}</h3>
                <p class="text-gray-400 mb-4">{project.description}</p>
                <div class="flex flex-wrap gap-2 mb-4">
                  {#each project.technologies as tech}
                    <span class="bg-zinc-900 text-primary-400 text-xs px-2 py-1 rounded border border-zinc-800">{tech}</span>
                  {/each}
                </div>
                <div class="flex gap-4">
                  {#if project.demo_url}
                    <a href={project.demo_url} target="_blank" rel="noopener" class="text-primary-500 hover:text-primary-400 transition-colors">Demo →</a>
                  {/if}
                  {#if project.github_url}
                    <a href={project.github_url} target="_blank" rel="noopener" class="text-primary-500 hover:text-primary-400 transition-colors">GitHub →</a>
                  {/if}
                </div>
              </div>
            {/each}
          </div>
        </div>
      </section>
    {/if}

    <!-- Experience Section -->
    {#if experience.length > 0}
      <section id="experience" class="py-16 md:py-24 bg-black">
        <div class="container mx-auto px-4 max-w-4xl">
          <h2 class="section-title text-center mb-12">Experience</h2>
          <div class="space-y-8">
            {#each experience as exp}
              <div class="border-l-4 border-primary-500 pl-6 py-4 hover:border-primary-400 transition-colors">
                <h3 class="text-2xl font-semibold text-white">{exp.position}</h3>
                <p class="text-lg text-gray-300 mb-2">{exp.company}</p>
                <p class="text-sm text-gray-500 mb-3">
                  {new Date(exp.start_date).toLocaleDateString()} - 
                  {exp.current ? 'Present' : (exp.end_date ? new Date(exp.end_date).toLocaleDateString() : 'N/A')}
                </p>
                <p class="text-gray-400 mb-3">{exp.description}</p>
                <div class="flex flex-wrap gap-2">
                  {#each exp.technologies as tech}
                    <span class="bg-zinc-900 text-primary-400 text-xs px-2 py-1 rounded border border-zinc-800">{tech}</span>
                  {/each}
                </div>
              </div>
            {/each}
          </div>
        </div>
      </section>
    {/if}

    <!-- Certifications Section -->
    {#if certifications.length > 0}
      <section id="certifications" class="py-16 md:py-24 bg-zinc-950">
        <div class="container mx-auto px-4 max-w-6xl">
          <h2 class="section-title text-center mb-12">Certifications</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {#each certifications as cert}
              <div class="card">
                <h3 class="text-xl font-semibold mb-2 text-white">{cert.name}</h3>
                <p class="text-gray-300 mb-2">{cert.issuer}</p>
                <p class="text-sm text-gray-500 mb-3">
                  Issued: {new Date(cert.issue_date).toLocaleDateString()}
                </p>
                {#if cert.credential_url}
                  <a href={cert.credential_url} target="_blank" rel="noopener" class="text-primary-500 hover:text-primary-400 transition-colors text-sm">
                    View Credential →
                  </a>
                {/if}
              </div>
            {/each}
          </div>
        </div>
      </section>
    {/if}

    <!-- Blog Section -->
    {#if blogPosts.length > 0}
      <section class="py-16 md:py-24 bg-black">
        <div class="container mx-auto px-4 max-w-6xl">
          <h2 class="section-title text-center mb-12">Blog</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {#each blogPosts as post}
              <div class="card group cursor-pointer">
                <h3 class="text-xl font-semibold mb-2 text-white group-hover:text-primary-400 transition-colors">{post.title}</h3>
                <p class="text-gray-400 mb-4">{post.excerpt}</p>
                <div class="flex flex-wrap gap-2 mb-4">
                  {#each post.tags as tag}
                    <span class="bg-zinc-900 text-primary-400 text-xs px-2 py-1 rounded border border-zinc-800">{tag}</span>
                  {/each}
                </div>
                <p class="text-sm text-gray-500">
                  {post.created_at ? new Date(post.created_at).toLocaleDateString() : ''}
                </p>
              </div>
            {/each}
          </div>
        </div>
      </section>
    {/if}

    <!-- Contact Section -->
    {#if contact}
      <section id="contact" class="py-16 md:py-24 bg-zinc-950">
        <div class="container mx-auto px-4 text-center max-w-4xl">
          <h2 class="section-title mb-12">Get In Touch</h2>
          <div class="card max-w-2xl mx-auto">
            <div class="space-y-4">
              <div class="flex items-center justify-center gap-3">
                <span class="text-primary-500 font-semibold">Email:</span>
                <a href="mailto:{contact.email}" class="text-gray-300 hover:text-primary-400 transition-colors">{contact.email}</a>
              </div>
              {#if contact.phone}
                <div class="flex items-center justify-center gap-3">
                  <span class="text-primary-500 font-semibold">Phone:</span>
                  <a href="tel:{contact.phone}" class="text-gray-300 hover:text-primary-400 transition-colors">{contact.phone}</a>
                </div>
              {/if}
              {#if contact.location}
                <div class="flex items-center justify-center gap-3">
                  <span class="text-primary-500 font-semibold">Location:</span>
                  <span class="text-gray-300">{contact.location}</span>
                </div>
              {/if}
              <div class="flex items-center justify-center gap-3">
                <span class="text-primary-500 font-semibold">Availability:</span>
                <span class="text-gray-300">{contact.availability}</span>
              </div>
            </div>
          </div>
        </div>
      </section>
    {/if}
  {/if}
</div>
