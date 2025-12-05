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
    <!-- Hero Section -->
    {#if hero}
      <section class="relative bg-gradient-to-b from-zinc-950 to-black text-white py-20 md:py-32 overflow-hidden">
        <!-- Background Media -->
        {#if hero.media_type === 'video' && hero.video_url}
          <div class="absolute inset-0 z-0">
            <video 
              autoplay 
              loop 
              muted 
              playsinline
              class="w-full h-full object-cover opacity-30"
            >
              <source src={hero.video_url} type="video/mp4" />
            </video>
            <div class="absolute inset-0 bg-gradient-to-b from-black/70 to-black/90"></div>
          </div>
        {:else if hero.media_type === 'image' && hero.image_url}
          <div class="absolute inset-0 z-0">
            <img 
              src={hero.image_url} 
              alt={hero.name}
              class="w-full h-full object-cover opacity-30"
            />
            <div class="absolute inset-0 bg-gradient-to-b from-black/70 to-black/90"></div>
          </div>
        {/if}

        <div class="container mx-auto px-4 max-w-6xl relative z-10">
          <h1 class="text-5xl md:text-7xl font-bold mb-4 bg-gradient-to-r from-primary-400 to-primary-600 bg-clip-text text-transparent">
            {hero.name}
          </h1>
          <p class="text-2xl md:text-3xl mb-4 text-gray-300">{hero.tagline}</p>
          <p class="text-lg mb-8 max-w-2xl text-gray-400">{hero.description}</p>
          <div class="flex flex-wrap gap-4">
            {#if hero.github_url}
              <a href={hero.github_url} target="_blank" rel="noopener" class="btn-primary">
                GitHub
              </a>
            {/if}
            {#if hero.linkedin_url}
              <a href={hero.linkedin_url} target="_blank" rel="noopener" class="btn-secondary">
                LinkedIn
              </a>
            {/if}
            {#if hero.twitter_url}
              <a href={hero.twitter_url} target="_blank" rel="noopener" class="btn-secondary">
                Twitter
              </a>
            {/if}
          </div>
        </div>
      </section>
    {/if}

    <!-- Skills Section -->
    {#if skills.length > 0}
      <section class="py-16 md:py-24 bg-black">
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
      <section class="py-16 md:py-24 bg-zinc-950">
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
      <section class="py-16 md:py-24 bg-black">
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
      <section class="py-16 md:py-24 bg-zinc-950">
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
      <section class="py-16 md:py-24 bg-zinc-950">
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
