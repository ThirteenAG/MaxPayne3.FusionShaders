sampler2D BumpSampler_layer0 : register(s1);
sampler2D BumpSampler_layer1 : register(s3);
sampler2D BumpSampler_layer2 : register(s5);
sampler2D BumpSampler_layer3 : register(s7);
sampler2D TextureSampler_layer0 : register(s0);
sampler2D TextureSampler_layer1 : register(s2);
sampler2D TextureSampler_layer2 : register(s4);
sampler2D TextureSampler_layer3 : register(s6);
float bumpiness : register(c2);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
sampler2D lookupSampler : register(s8);
float specularColorFactor : register(c1);
float specularFactor : register(c0);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float3 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
};

struct PS_OUT
{
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color2 : COLOR2;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float3 r4;
	float4 r5;
	r0 = i.texcoord.xyxx * float4(1, 1, 0, 0) + float4(0, 0, 0, -1.3);
	r1 = tex2Dbias(TextureSampler_layer0, r0);
	r2 = tex2Dbias(TextureSampler_layer1, r0);
	r3 = tex2D(lookupSampler, i.texcoord.zw);
	r4 = -r3.xyz + 1;
	r1.w = r4.y * r4.x;
	r2.w = r3.z * r1.w;
	r1.w = r4.z * r1.w;
	r2.xyz = r2.www * r2.xyz;
	r1.xyz = r1.xyz * r1.www + r2.xyz;
	r5 = tex2Dbias(TextureSampler_layer2, r0);
	r0 = tex2Dbias(TextureSampler_layer3, r0);
	r0.w = r3.y * r4.x;
	r2.x = r3.z * r0.w;
	r0.w = r4.z * r0.w;
	r1.xyz = r5.xyz * r0.www + r1.xyz;
	r0.xyz = r0.xyz * r2.xxx + r1.xyz;
	r1.x = saturate(-1 + i.texcoord3.w);
	r1.x = r1.x * globalScalars2.z;
	o.color.xyz = r0.xyz * i.texcoord3.xyz + r1.xxx;
	r3 = tex2D(BumpSampler_layer1, i.texcoord.xy);
	r0.x = -r3.w + 1;
	r0.x = -r3.x + r0.x;
	r0.xy = (r0.xx >= 0) ? r3.wy : r3.xy;
	r0.xy = r2.ww * r0.xy;
	r3 = tex2D(BumpSampler_layer0, i.texcoord.xy);
	r0.z = -r3.w + 1;
	r0.z = -r3.x + r0.z;
	r1.xy = (r0.zz >= 0) ? r3.wy : r3.xy;
	r0.xy = r1.xy * r1.ww + r0.xy;
	r1 = tex2D(BumpSampler_layer2, i.texcoord.xy);
	r0.z = -r1.w + 1;
	r0.z = -r1.x + r0.z;
	r1.xy = (r0.zz >= 0) ? r1.wy : r1.xy;
	r0.xy = r1.xy * r0.ww + r0.xy;
	r1 = tex2D(BumpSampler_layer3, i.texcoord.xy);
	r0.z = -r1.w + 1;
	r0.z = -r1.x + r0.z;
	r0.zw = (r0.zz >= 0) ? r1.wy : r1.xy;
	r0.xy = r0.zw * r2.xx + r0.xy;
	r0.xy = r0.xy + -0.5;
	r0.xy = r0.xy * bumpiness.xx;
	r0.xy = r0.xy + r0.xy;
	r1.xyz = r0.xxx * i.texcoord4.xyz;
	r0.x = dot(r0.xy, -r0.xy) + 1;
	r1.w = max(r0.x, 0);
	r0.x = rsqrt(r1.w);
	r0.x = 1 / r0.x;
	r0.xzw = i.texcoord2.xyz * r0.xxx + r1.xyz;
	r0.xyz = r0.yyy * i.texcoord5.xyz + r0.xzw;
	r0.xyz = r0.xyz + 1E-05;
	r1.xyz = normalize(r0.xyz);
	o.color1.xyz = r1.xyz * 0.5 + 0.5;
	r0.y = 0.0051020407;
	r0.x = saturate(r0.y * specularFactor.x);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = rsqrt(r0.x);
	o.color2.y = 1 / r0.x;
	o.color2.z = gAmbientOcclusionEffect.w * i.texcoord3.w;
	o.color.w = 0;
	o.color1.w = globalScalars.x;
	o.color2.x = specularColorFactor.x;
	o.color2.w = globalScalars.x;
	r0.xy = float2(1, 0);
	o.color3 = r0.yyyx * gStencil.x;

	return o;
}
