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
    <nav class="fixed top-0 left-0 right-0 z-50 bg-black/80 backdrop-blur-md border-b border-zinc-900">
      <div class="container mx-auto px-4 py-4 flex items-center justify-between">
        <div class="flex items-center gap-2">
          <span class="text-primary-500 text-2xl">⚡</span>
          <span class="text-white font-bold text-xl">PORTFOLIO</span>
        </div>
        <div class="hidden md:flex items-center gap-8">
          <a href="#home" class="text-gray-300 hover:text-primary-500 transition-colors">Home</a>
          <a href="#skills" class="text-gray-300 hover:text-primary-500 transition-colors">Skills</a>
          <a href="#projects" class="text-gray-300 hover:text-primary-500 transition-colors">Projects</a>
          <a href="#experience" class="text-gray-300 hover:text-primary-500 transition-colors">Experience</a>
          <a href="#certifications" class="text-gray-300 hover:text-primary-500 transition-colors">Certifications</a>
          <a href="#contact" class="text-gray-300 hover:text-primary-500 transition-colors">Contact</a>
        </div>
      </div>
    </nav>

    <!-- Hero Section -->
    {#if hero}
      <section id="home" class="relative min-h-screen bg-black text-white pt-24 pb-16 flex items-center">
        <div class="container mx-auto px-4 max-w-7xl">
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            <!-- Left Content -->
            <div class="space-y-6">
              <!-- Available Badge -->
              <div class="inline-flex items-center gap-2 px-4 py-2 bg-zinc-900 border border-zinc-800 rounded-full">
                <span class="w-2 h-2 bg-primary-500 rounded-full animate-pulse"></span>
                <span class="text-sm text-gray-300">Available for opportunities</span>
              </div>

              <!-- Name -->
              <h1 class="text-6xl md:text-7xl lg:text-8xl font-bold text-white leading-tight">
                {hero.name}
              </h1>

              <!-- Tagline -->
              <p class="text-2xl md:text-3xl text-primary-500 font-medium">
                {hero.tagline}
              </p>

              <!-- Description -->
              <p class="text-lg text-gray-400 leading-relaxed max-w-xl">
                {hero.description}
              </p>

              <!-- Action Buttons -->
              <div class="flex flex-wrap gap-4 pt-4">
                <a href="#projects" class="btn-primary">
                  View Projects
                </a>
                {#if hero.resume_url}
                  <a href={hero.resume_url} target="_blank" rel="noopener" class="btn-secondary">
                    Download Resume
                  </a>
                {/if}
              </div>

              <!-- Social Links -->
              <div class="flex gap-4 pt-6">
                {#if hero.github_url}
                  <a href={hero.github_url} target="_blank" rel="noopener" class="text-gray-400 hover:text-primary-500 transition-colors">
                    <svg class="w-8 h-8" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/>
                    </svg>
                  </a>
                {/if}
                {#if hero.linkedin_url}
                  <a href={hero.linkedin_url} target="_blank" rel="noopener" class="text-gray-400 hover:text-primary-500 transition-colors">
                    <svg class="w-8 h-8" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/>
                    </svg>
                  </a>
                {/if}
                {#if hero.twitter_url}
                  <a href={hero.twitter_url} target="_blank" rel="noopener" class="text-gray-400 hover:text-primary-500 transition-colors">
                    <svg class="w-8 h-8" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z"/>
                    </svg>
                  </a>
                {/if}
              </div>
            </div>

            <!-- Right Content - Video/Image -->
            <div class="relative">
              {#if hero.media_type === 'video' && hero.video_url}
                <div class="relative rounded-2xl overflow-hidden shadow-2xl border border-zinc-800 bg-zinc-900 p-4">
                  <div class="bg-white rounded-lg overflow-hidden">
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
              {:else if hero.media_type === 'image' && hero.image_url}
                <div class="relative rounded-2xl overflow-hidden shadow-2xl border border-zinc-800 bg-zinc-900 p-4">
                  <div class="bg-white rounded-lg overflow-hidden">
                    <img 
                      src={hero.image_url} 
                      alt={hero.name}
                      class="w-full h-auto"
                    />
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
